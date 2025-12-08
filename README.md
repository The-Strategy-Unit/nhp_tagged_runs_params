# nhp_tagged_runs_params

## About

A scheduled Quarto report that generates and [pins](https://pins.rstudio.com/) to Posit Connect:

* a list object containing the model params for each NHP scheme's [tagged model runs](https://connect.strategyunitwm.nhs.uk/nhp/tagged_runs)
* a data.frame object containing metadata associated with the tagged runs

The pins make it easier and faster to ingest params data into products like [the Compare NHP Activity Mitigation Predictions app](https://github.com/The-Strategy-Unit/nhp_mitigator_comparisons_app), for example.
This is a workaround because the results files are very large but certain tasks only require the params component.
In future, the params and results files will be stored separately, reducing the need for this functionality.

## Products

The products of this repo are available on Posit Connect (login required):

* [the rendered report](https://connect.strategyunitwm.nhs.uk/nhp/tagged-runs-params-report/)
* [the params pin](https://connect.strategyunitwm.nhs.uk/content/2784320a-dfa4-4694-866f-9c84741568da/)
* [the params metadata pin](https://connect.strategyunitwm.nhs.uk/content/022974aa-dd54-4e33-aed3-42c34f81bc9d/)

## Data

The data handled in this report is collected from:

* Azure Table Storage, where we have a lookup that lists scenarios tagged with a run stage
* Azure Blob Storage, where we have a container of model results files

See separate guidance on SharePoint for how to add or update scenarios that have a run-stage.

## Redeploy

If you make changes to the code in this repo, you can redeploy the report to Posit Connect using the `deploy.R` script.

## Refresh

The report runs on POsit Connect on schedule, so any changes to the underlying data will be integrated on the next rendering.
You may wish to manually refresh the app from Posit Connect if you want your changes to appear more quickly.
To do this, open the app from the Posit Connect 'Content' page and click the 'refresh report' button (circular arrow) in the upper-right of the interface.

## Render locally

If you need to generate the report from your machine:

1. Create a `.Renviron` file in the project root using `.Renviron.sample` as a template.
Ask a member of the Data Science team for the values required by each variable.
2. Render the `index.qmd` template to an HTML file, which will also republish the pins to Connect

During this process, you may be prompted to authorise with Azure through the browser.
See [the Data Science website](https://the-strategy-unit.github.io/data_science/presentations/2024-05-16_store-data-safely/#/authenticating-to-azure-data-storage) for detail on authorisation.
