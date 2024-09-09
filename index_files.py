import os
import meilisearch
import requests

# MeiliSearch instance URL and master key
MEILISEARCH_URL = 'http://127.0.0.1:7700'
MASTER_KEY = 'REPLACE_WITH_YOUR_MASTER_KEY'  # Replace with your actual master key

# Step 1: Generate an API key using the master key
def generate_api_key():
    headers = {
        'Authorization': f'Bearer {MASTER_KEY}',
        'Content-Type': 'application/json'
    }
    data = {
        "description": "Generated API key",
        "actions": ["*"],  # Allow all actions
        "indexes": ["*"],  # Allow all indexes
        "expiresAt": None  # No expiration
    }
    response = requests.post(f'{MEILISEARCH_URL}/keys', headers=headers, json=data)
    if response.status_code == 201:
        api_key = response.json()['key']
        print(f"Generated API key: {api_key}")
        return api_key
    else:
        print(f"Failed to generate API key: {response.json()}")
        return None

# Step 2: Use the generated API key to interact with MeiliSearch
def index_documents(api_key):
    client = meilisearch.Client(MEILISEARCH_URL, api_key)

    # Create or use an existing index called 'documents'
    index = client.index('documents')

    # Directory containing documents to be indexed
    documents_dir = '/documents'

    # Index all text files in the directory
    documents = []
    for filename in os.listdir(documents_dir):
        if filename.endswith('.txt'):
            with open(os.path.join(documents_dir, filename), 'r') as file:
                content = file.read()
                documents.append({
                    'id': filename,
                    'content': content
                })

    # Add the documents to MeiliSearch
    index.add_documents(documents)

    print(f"Indexed {len(documents)} documents from {documents_dir}.")

# Generate an API key and use it to index documents
api_key = generate_api_key()
if api_key:
    index_documents(api_key)
