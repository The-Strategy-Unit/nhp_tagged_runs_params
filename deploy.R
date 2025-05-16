# Deploy to the current and new Posit Connect servers. The current server
# (strategyunitwm.nhs.uk) will be switched off in May/June 2025 and the new
# server (currently named su.mlcsu.org) will take its name.

deploy <- function(server_name, app_id) {
  rsconnect::deployDoc(
    server = server_name,
    appId = app_id,
    doc = "index.qmd",
    appName = "nhp_tagged_runs_params_report",
    appTitle = "NHP: tagged-runs param-extraction report",
    lint = FALSE,
    forceUpdate = TRUE
  )
}

deploy("connect.strategyunitwm.nhs.uk", 302)
deploy("connect.su.mlcsu.org", 115)
