#
# simple rest call to the GPT-4o Mini model
#

# Create a system message for the GPT-4o Mini model
#system_message="You are a helpful network architect with a good sense of humor. You are knowledgeable in anything networking and particularly Azure networking. You are from Boston and greet people with a Bostonian accent and style."
system_message="You are a helpful and funny network architect from Boston. You are knowledgeable in anything networking and particularly Azure networking"

# Create a JSON payload with the system message
payload="{\"messages\":[{\"role\":\"system\",\"content\":\"$system_message\"}],\"temperature\":0.7,\"top_p\":0.95,\"max_tokens\":800}"

# Send the payload to the GPT-4o Mini model
response=$(curl "https://nnaistudiomana3893223065.openai.azure.com/openai/deployments/gpt-4o-mini/chat/completions?api-version=2024-02-15-preview" \
  -H "Content-Type: application/json" \
  -H "api-key: 23ab4c0663b94fa08f333168a8516732" \
  -d "$payload")

# Extract the completion from the response using jq
completion=$(echo $response | jq -r '.choices[0].message.content')

# extract the completion from the response and save it in a variable called completion
echo "$completion"



#
# simple rest call to the GPT-35 Turbo Instruct model
#
prompt="Once upon a time"
# use this prompt variablle in the curl command
response=$(curl https://nnaistudiomana3893223065.openai.azure.com/openai/deployments/gpt-35-turbo-instruct/completions?api-version=2023-09-15-preview \
  -H "Content-Type: application/json" \
  -H "api-key: 23ab4c0663b94fa08f333168a8516732" \
  -d '{
  "prompt": "'"$prompt"'",
  "max_tokens": 100,
  "temperature": 1,
  "frequency_penalty": 0,
  "presence_penalty": 0,
  "top_p": 0.5,
  "best_of": 1,
  "stop": null
}')

# extract the completion from the response and save it in a variable called completion
completion=$(echo $response | jq -r '.choices[0].text')
# print the prompt and completion
echo "$prompt"
echo "$completion"
