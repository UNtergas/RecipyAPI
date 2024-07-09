# Set-Location -Path $PSScriptRoot

# Run flake8 command in the Docker container
docker-compose run --rm app sh -c "python manage.py test"