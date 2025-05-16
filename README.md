# nhp_tagged_runs_params

## About

A scheduled Quarto report that generates and [pins](https://pins.rstudio.com/) to Posit Connect:

* a list object containing the model params for each NHP scheme's latest [tagged model run](https://connect.strategyunitwm.nhs.uk/nhp/tagged_runs)
* a data.frame object containing metadata associated with the tagged runs

The pins make it easier and faster to ingest params data into products like [the mitigators-comparison app](https://github.com/The-Strategy-Unit/nhp_inputs_report_app), for example.
This is a workaround because the results files are very large but certain tasks only require the params component.
In future, the params and results files will be stored separately, reducing the need for this functionality.

## Products

The products of this repo are available on Posit Connect (login required):

* [the rendered report](https://connect.strategyunitwm.nhs.uk/nhp/tagged-runs-params-report/)
* [the params pin](https://connect.strategyunitwm.nhs.uk/content/32c7f642-e420-448d-b888-bf655fc8fa8b/)
* [the params metadata pin](https://connect.strategyunitwm.nhs.uk/content/811dbaf9-18fe-43aa-bf8e-06b0df66004e/)

## Data

The data processed by the report is collected from the model results files, hosted on Azure in the container given by the environmental variable `AZ_STORAGE_CONTAINER_RESULTS`.
See the [separate guidance](https://csucloudservices.sharepoint.com/:w:/r/sites/HEUandSUProjects/_layouts/15/Doc.aspx?sourcedoc=%7BE9BF237E-BA81-4F7E-90B1-2CA3A003F5A1%7D&file=2024-08-24_tagging-nhp-model-runs.docx&action=default&mobileredirect=true) for how to tag results files with run stage metadata.

## Redeploy

If you make changes to the code in this repo, you can redeploy the report to Posit Connect using the `deploy.R` script.

## Refresh

The report runs on schedule, so any changes to the underlying data will be integrated on the next rendering.
You may wish to manually refresh the app from Posit Connect if you want your changes to appear more quickly.
To do this, open the app from the Posit Connect 'Content' page and click the 'refresh report' button (circular arrow) in the upper-right of the interface.

## Render locally

If you need to generate the report from your machine:

1. Create a `.Renviron` file in the project root using `.Renviron.sample` as a template.
Ask a member of the Data Science team for the values required by each variable.
2. Knit the `index.Rmd` template to an HTML file, which will also republish the pins to Connect

During this process, you may be prompted to authorise with Azure through the browser. 
See [the Data Science website](https://the-strategy-unit.github.io/data_science/presentations/2024-05-16_store-data-safely/#/authenticating-to-azure-data-storage) for detail on authorisation.
