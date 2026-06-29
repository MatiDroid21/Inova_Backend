#!/bin/bash
# =============================================================
#  infra-setup.sh — Innovatech Chile | AWS Academy
#  Región: us-east-1 | AMI: Amazon Linux 2023 | t2.micro
#  Crea: VPC, Subnets, IGW, Routes, SGs, Key Pair, 2x EC2
# =============================================================
set -e  # Detener si cualquier comando falla

# ─── VARIABLES ──────────────────────────────────────────────
REGION="us-east-1"
AZ="us-east-1a"
PROJECT="innovatech"
KEY_NAME="${PROJECT}-keypair"
AMI_ID="ami-0453ec754f44f9a4a"   # Amazon Linux 2023 (us-east-1) — verificar vigencia
INSTANCE_TYPE="t2.micro"

VPC_CIDR="10.0.0.0/16"
SUBNET_PUB_CIDR="10.0.1.0/24"
SUBNET_PRIV_CIDR="10.0.2.0/24"

echo "======================================================"
echo "  Innovatech Chile — Infraestructura AWS"
echo "======================================================"

# ─── 1. KEY PAIR ───────────────────────────────────────────
echo ""
echo "[1/9] Creando Key Pair..."
aws ec2 create-key-pair \
  --key-name "$KEY_NAME" \
  --region "$REGION" \
  --query "KeyMaterial" \
  --output text > "${KEY_NAME}.pem"

chmod 400 "${KEY_NAME}.pem"
echo "  ✅ Key Pair creado: ${KEY_NAME}.pem"

# ─── 2. VPC ───────────────────────────────────────────────
echo ""
echo "[2/9] Creando VPC..."
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block "$VPC_CIDR" \
  --region "$REGION" \
  --query "Vpc.VpcId" --output text)

aws ec2 create-tags --resources "$VPC_ID" \
  --tags Key=Name,Value="${PROJECT}-vpc" --region "$REGION"

aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" \
  --enable-dns-hostnames --region "$REGION"

echo "  ✅ VPC: $VPC_ID"

# ─── 3. SUBNETS ────────────────────────────────────────────
echo ""
echo "[3/9] Creando Subnets..."

SUBNET_PUB_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block "$SUBNET_PUB_CIDR" \
  --availability-zone "$AZ" \
  --region "$REGION" \
  --query "Subnet.SubnetId" --output text)

aws ec2 create-tags --resources "$SUBNET_PUB_ID" \
  --tags Key=Name,Value="${PROJECT}-subnet-publica" --region "$REGION"

aws ec2 modify-subnet-attribute --subnet-id "$SUBNET_PUB_ID" \
  --map-public-ip-on-launch --region "$REGION"

SUBNET_PRIV_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block "$SUBNET_PRIV_CIDR" \
  --availability-zone "$AZ" \
  --region "$REGION" \
  --query "Subnet.SubnetId" --output text)

aws ec2 create-tags --resources "$SUBNET_PRIV_ID" \
  --tags Key=Name,Value="${PROJECT}-subnet-privada" --region "$REGION"

echo "  ✅ Subnet pública:  $SUBNET_PUB_ID"
echo "  ✅ Subnet privada:  $SUBNET_PRIV_ID"

# ─── 4. INTERNET GATEWAY ────────────────────────────────────
echo ""
echo "[4/9] Creando Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --region "$REGION" \
  --query "InternetGateway.InternetGatewayId" --output text)

aws ec2 attach-internet-gateway \
  --internet-gateway-id "$IGW_ID" \
  --vpc-id "$VPC_ID" --region "$REGION"

aws ec2 create-tags --resources "$IGW_ID" \
  --tags Key=Name,Value="${PROJECT}-igw" --region "$REGION"

echo "  ✅ IGW: $IGW_ID"

# ─── 5. ROUTE TABLE PÚBLICA ────────────────────────────────
echo ""
echo "[5/9] Configurando Route Table pública..."
RT_ID=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" --region "$REGION" \
  --query "RouteTable.RouteTableId" --output text)

aws ec2 create-route \
  --route-table-id "$RT_ID" \
  --destination-cidr-block "0.0.0.0/0" \
  --gateway-id "$IGW_ID" --region "$REGION" > /dev/null

aws ec2 associate-route-table \
  --route-table-id "$RT_ID" \
  --subnet-id "$SUBNET_PUB_ID" --region "$REGION" > /dev/null

aws ec2 create-tags --resources "$RT_ID" \
  --tags Key=Name,Value="${PROJECT}-rt-publica" --region "$REGION"

echo "  ✅ Route Table pública: $RT_ID"

# ─── 6. SECURITY GROUP — FRONTEND ──────────────────────────
echo ""
echo "[6/9] Creando Security Groups..."

SG_FRONT_ID=$(aws ec2 create-security-group \
  --group-name "${PROJECT}-sg-frontend" \
  --description "SG Frontend Innovatech - HTTP/HTTPS publico + SSH" \
  --vpc-id "$VPC_ID" --region "$REGION" \
  --query "GroupId" --output text)

# HTTP desde Internet
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_FRONT_ID" --region "$REGION" \
  --protocol tcp --port 80 --cidr 0.0.0.0/0

# HTTPS desde Internet
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_FRONT_ID" --region "$REGION" \
  --protocol tcp --port 443 --cidr 0.0.0.0/0

# SSH desde cualquier IP (AWS Academy)
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_FRONT_ID" --region "$REGION" \
  --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 create-tags --resources "$SG_FRONT_ID" \
  --tags Key=Name,Value="${PROJECT}-sg-frontend" --region "$REGION"

echo "  ✅ SG Frontend: $SG_FRONT_ID"

# ─── 7. SECURITY GROUP — BACKEND ───────────────────────────
SG_BACK_ID=$(aws ec2 create-security-group \
  --group-name "${PROJECT}-sg-backend" \
  --description "SG Backend Innovatech - solo trafico desde SG frontend" \
  --vpc-id "$VPC_ID" --region "$REGION" \
  --query "GroupId" --output text)

# Puerto 8080 (Ventas) solo desde SG Frontend
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_BACK_ID" --region "$REGION" \
  --protocol tcp --port 8080 \
  --source-group "$SG_FRONT_ID"

# Puerto 8081 (Despachos) solo desde SG Frontend
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_BACK_ID" --region "$REGION" \
  --protocol tcp --port 8081 \
  --source-group "$SG_FRONT_ID"

# MySQL solo dentro de la VPC
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_BACK_ID" --region "$REGION" \
  --protocol tcp --port 3306 --cidr "$VPC_CIDR"

# SSH para gestion
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_BACK_ID" --region "$REGION" \
  --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 create-tags --resources "$SG_BACK_ID" \
  --tags Key=Name,Value="${PROJECT}-sg-backend" --region "$REGION"

echo "  ✅ SG Backend:   $SG_BACK_ID"

# ─── 8. EC2 FRONTEND (subnet pública) ────────────────────────
echo ""
echo "[8/9] Lanzando instancias EC2..."

USER_DATA_FRONT=$(cat <<'USERDATA'
#!/bin/bash
yum update -y
yum install -y docker git
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
cd /home/ec2-user
git clone https://github.com/KeitonChaves/Innovatech_Frontend.git
chown -R ec2-user:ec2-user Innovatech_Frontend
USERDATA
)

EC2_FRONT_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --subnet-id "$SUBNET_PUB_ID" \
  --security-group-ids "$SG_FRONT_ID" \
  --user-data "$USER_DATA_FRONT" \
  --region "$REGION" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${PROJECT}-ec2-frontend}]" \
  --query "Instances[0].InstanceId" --output text)

echo "  ✅ EC2 Frontend: $EC2_FRONT_ID"

# ─── 9. EC2 BACKEND (subnet privada) ────────────────────────
USER_DATA_BACK=$(cat <<'USERDATA'
#!/bin/bash
yum update -y
yum install -y docker git
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
cd /home/ec2-user
git clone https://github.com/KeitonChaves/Innovatech_Backend.git
chown -R ec2-user:ec2-user Innovatech_Backend
USERDATA
)

EC2_BACK_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --subnet-id "$SUBNET_PRIV_ID" \
  --security-group-ids "$SG_BACK_ID" \
  --user-data "$USER_DATA_BACK" \
  --region "$REGION" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${PROJECT}-ec2-backend}]" \
  --query "Instances[0].InstanceId" --output text)

echo "  ✅ EC2 Backend:  $EC2_BACK_ID"

# ─── ESPERAR IPs ─────────────────────────────────────────────
echo ""
echo "⏳ Esperando que las instancias estén running..."
aws ec2 wait instance-running --instance-ids "$EC2_FRONT_ID" "$EC2_BACK_ID" --region "$REGION"

EC2_FRONT_IP=$(aws ec2 describe-instances \
  --instance-ids "$EC2_FRONT_ID" --region "$REGION" \
  --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

EC2_BACK_IP=$(aws ec2 describe-instances \
  --instance-ids "$EC2_BACK_ID" --region "$REGION" \
  --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)

# ─── RESUMEN FINAL ──────────────────────────────────────────
echo ""
echo "======================================================"
echo "  ✅  INFRAESTRUCTURA CREADA EXITOSAMENTE"
echo "======================================================"
echo ""
echo "  VPC:              $VPC_ID"
echo "  Subnet pública:   $SUBNET_PUB_ID  ($SUBNET_PUB_CIDR)"
echo "  Subnet privada:   $SUBNET_PRIV_ID  ($SUBNET_PRIV_CIDR)"
echo "  IGW:              $IGW_ID"
echo "  SG Frontend:      $SG_FRONT_ID"
echo "  SG Backend:       $SG_BACK_ID"
echo ""
echo "  EC2 Frontend IP pública:  $EC2_FRONT_IP"
echo "  EC2 Backend  IP privada:  $EC2_BACK_IP"
echo ""
echo "  Key Pair: ./${KEY_NAME}.pem"
echo ""
echo "======================================================"
echo "  PRÓXIMOS PASOS"
echo "======================================================"
echo ""
echo "  1. SSH al frontend:"
echo "     ssh -i ${KEY_NAME}.pem ec2-user@$EC2_FRONT_IP"
echo ""
echo "  2. En EC2 Backend, crear .env:"
echo "     cd ~/Innovatech_Backend"
echo "     cp .env.example .env && nano .env"
echo ""
echo "  3. Levantar backend:"
echo "     docker compose up -d --build"
echo ""
echo "  4. En EC2 Frontend, crear .env:"
echo "     echo \"VITE_API_URL=http://${EC2_BACK_IP}:8081\" > .env"
echo ""
echo "  5. Levantar frontend:"
echo "     docker compose up -d --build"
echo ""
echo "  6. Abrir en navegador:"
echo "     http://$EC2_FRONT_IP"
echo ""
echo "  7. Secrets GitHub Actions:"
echo "     EC2_HOST=$EC2_FRONT_IP"
echo "     VITE_API_URL=http://$EC2_BACK_IP:8081"
echo ""
