from dotenv import load_dotenv
from google.cloud import bigquery
import pandas as pd
import os

load_dotenv()

PROJECT_ID = os.getenv('PROJECT_ID')
DATASET_ID = os.getenv('DATASET_ID', 'planflow_raw')
FILE = 'Base_Case_PlanFlow.xlsx'

if not PROJECT_ID:
    raise SystemExit('PROJECT_ID não definido: crie o .env a partir do .env.example')

bq_client = bigquery.Client(project=PROJECT_ID)

try:
    print('Verificando se o dataset já existe')
    bq_client.create_dataset(DATASET_ID)
    print('Dataset não existia e foi criado')
except Exception:
    print('Dataset já existia')

# Camada raw: tudo como texto, menos as colunas numéricas e de timestamp
sheets = pd.read_excel(FILE, sheet_name=None, dtype=str)

for sheet_name, df in sheets.items():
    for col in ['tma_minutes', 'quality_score', 'scheduled_hours']:
        if col in df.columns:
            df[col] = df[col].astype(float)
    if 'csat_score' in df.columns:
        df['csat_score'] = df['csat_score'].astype('Int64')
    if 'response_datetime' in df.columns:
        df['response_datetime'] = pd.to_datetime(df['response_datetime'])

    table_id = f'{PROJECT_ID}.{DATASET_ID}.{sheet_name.lower()}'
    job_config = bigquery.LoadJobConfig(write_disposition='WRITE_TRUNCATE')

    print(f'Fazendo upload da tabela {table_id}')
    try:
        load_job = bq_client.load_table_from_dataframe(df, table_id, job_config=job_config)
        load_job.result()
        print(f'{len(df)} linhas carregadas')
    except Exception as e:
        print(f'Upload da tabela {table_id} falhou')
        print(e)
