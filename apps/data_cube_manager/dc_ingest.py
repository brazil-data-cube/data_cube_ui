'''
These files were extracted from the datacube. They are used in some parts of the data_cube_manager module
'''


from copy import deepcopy
from datacube.model import DatasetType


def morph_dataset_type(source_type, config):
    output_type = DatasetType(source_type.metadata_type, deepcopy(source_type.definition))
    output_type.definition['name'] = config['output_type']
    output_type.definition['managed'] = True
    output_type.definition['description'] = config['description']
    output_type.definition['storage'] = config['storage']
    output_type.metadata_doc['format'] = {'name': 'NetCDF'}

    def merge_measurement(measurement, spec):
        measurement.update({k: spec.get(k, measurement[k]) for k in ('name', 'nodata', 'dtype')})
        return measurement

    output_type.definition['measurements'] = [merge_measurement(output_type.measurements[spec['src_varname']], spec)
                                              for spec in config['measurements']]
    return output_type


def make_output_type(index, config):
    source_type = index.products.get_by_name(config['source_type'])
    output_type = morph_dataset_type(source_type, config)
    output_type = index.products.add(output_type)

    return source_type, output_type
