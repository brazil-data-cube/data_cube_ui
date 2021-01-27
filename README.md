CEOS Data Cube UI
=================

The CEOS Data Cube UI is a full stack Python web application used to perform analysis on raster datasets using the Data Cube. Using common and widely accepted frameworks and libraries, our UI is a good tool for demonstrating the Data Cube capabilities and some possible applications and architectures. The UI's core technologies are:
* [**Django**](https://www.djangoproject.com/): Web framework, ORM, template processor, entire MVC stack
* [**Celery + Redis**](http://www.celeryproject.org/): Asynchronous task processing
* [**Open Data Cube**](http://datacube-core.readthedocs.io/en/stable/): API for data access and analysis
* [**PostgreSQL**](https://www.postgresql.org/): Database backend for both the Data Cube and our UI
* [**Apache/Mod WSGI**](https://en.wikipedia.org/wiki/Mod_wsgi): Standard service based application running our Django application while still providing hosting for static files
* [**Bootstrap3**](http://getbootstrap.com/): Simple, standard, and easy front end styling

Using these common technologies provides a good starting platform for users who want to develop Data Cube applications. Using Celery allows for simple distributed task processing while still being performant. Our UI is designed for high level use of the Data Cube and allow users to:
* Access various datasets that we have ingested
* Run custom analysis cases over user defined areas and time ranges
* Generate both visual (image) and data products (GeoTiff/NetCDF)
* Provide easy access to metadata and previously run analysis cases

To install Open Data Cube Core (ODC Core), see the 
[Open Data Cube Core Installation Guide](docs/open_data_cube_install.md).

Once you have ODC Core installed, you can install the UI by following the 
[Data Cube UI Installation Guide](docs/ui_install.md).

Installation
=================
First follow the instructions in the 
[Open Data Cube Database Installation Guide](docs/odc_db_setup.md)
to setup the Open Data Cube (ODC) database.

Follow the instructions in the [Open Data Cube UI Installation Guide](docs/ui/ui_install.md)
to install the ODC UI. That document also contains troubleshooting information for the UI in
the form of an FAQ.

Follow the instructions in the [Open Data Cube UI Algorithm Addition Guide](docs/adding_new_pages.md)
to add new applications to the ODC UI. This guide is only intended for programmers.

Follow the instructions in the [Open Data Cube Indexing and Ingestion Guide](docs/indexing_and_ingestion.md)
to learn how to index and ingest data for an Open Data Cube installation - particularly
for the ODC UI.

> Note: In this fork, the use of the Docker is recommended. If you want to use it manually, it will be necessary to change the files that describe Apache's paths. For more information, consult the [official documentation](https://github.com/ceos-seo/data_cube_ui/blob/72dd9eb05d7c6747892ef8d427475b0dcc0064df/docs/ui_install.md#-configuring-the-server).

Obtaining Help
=================
If you encounter issues that are not documented in the documents linked to above or 
the other files in the `docs` directory (remember to check the FAQ sections) and 
you are unable to diagnose and fix those issues on your own, follow these steps to obtain assistance:
1. Post your question in the [GIS Stack Exchange](https://gis.stackexchange.com/) 
   with the `open-data-cube` tag. You can find such tagged questions [here](https://gis.stackexchange.com/questions/tagged/open-data-cube).
2. State your problem in the ODC Slack workspace in the most appropriate channel.
   Link to the question you posted on GIS Stack Exchange.
   Use the **#general** channel if no other channel is appropriate for your question.
   You can join the ODC Slack workspace [here](http://slack.opendatacube.org/).
