param (
    [string[]]$Commands
)

# Prefix each command with 'python manage.py' and join them with ' && '
$commandsString = ($Commands | ForEach-Object { "python manage.py $_" }) -join " && "

# Define the Docker Compose command
$dockerComposeCommand = "docker-compose run --rm app sh -c `"$commandsString`""

# Execute the Docker Compose command
Invoke-Expression $dockerComposeCommand
