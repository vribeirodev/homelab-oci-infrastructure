#!/bin/bash

echo "Script de retry para provisionar ARM A1.Flex"
echo "Pressione Ctrl+C para cancelar"
echo "=========================================="

RETRY_COUNT=0
MAX_RETRIES=100
WAIT_TIME=10  # 5 minutos entre tentativas

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "Tentativa $RETRY_COUNT de $MAX_RETRIES..."
    echo "$(date): Iniciando terraform apply"

    # Tentar terraform apply
    terraform apply -auto-approve

    # Verificar se foi bem sucedido
    if [ $? -eq 0 ]; then
        echo "SUCCESS! Cluster criado com sucesso!"
        exit 0
    fi

    # Se falhou, verificar se foi por falta de capacidade
    echo "$(date): Falhou. Aguardando $WAIT_TIME segundos antes da próxima tentativa..."
    echo "Tentativa $RETRY_COUNT/$MAX_RETRIES"

    # Limpar estado falho
    terraform destroy -target=module.oke_cluster.oci_containerengine_node_pool.oke_node_pool -auto-approve

    # Aguardar antes da próxima tentativa
    sleep $WAIT_TIME
done

echo "Máximo de tentativas atingido. Tente novamente mais tarde."
exit 1