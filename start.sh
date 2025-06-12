#!/bin/bash

# Optional R setup script
Rscript -e "source('/opt/DIMSpec/R/compliance.R')"

echo "Starting Shiny Apps..."

# Create log directory if it doesn't exist
mkdir -p /var/log/shinyapps

# Start each app in the background and redirect output to log files
R -e "shiny::runApp(file.path('inst', 'apps', 'msmatch'), host = '0.0.0.0', port = 7000)" \
  > /var/log/shinyapps/msmatch.log 2>&1 &

R -e "shiny::runApp(file.path('inst', 'apps', 'table_explorer'), host = '0.0.0.0', port = 7001)" \
  > /var/log/shinyapps/table_explorer.log 2>&1 &

R -e "shiny::runApp(file.path('inst', 'apps', 'dimspec-qc'), host = '0.0.0.0', port = 7002)" \
  > /var/log/shinyapps/dimspec-qc.log 2>&1 &

# Prevent the container from exiting
wait
