try:
    import apps.data_cube_manager.tasks as dcmt
    dcmt.update_data_cube_details()
except BaseException as e:
    print("Error in Update datacube details: " + str(e))
