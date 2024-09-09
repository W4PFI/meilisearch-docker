import os
import sys
import meilisearch

# MeiliSearch client
client = meilisearch.Client('http://127.0.0.1:7700')

# Create or use an existing index called 'documents'
index = client.index('documents')

# Directory to be indexed (shared directory)
documents_dir = sys.argv[1]

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
