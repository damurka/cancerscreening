
get_lab_fluid_cytology <- function(start_date,
                                   end_date = NULL,
                                   level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                   organisations = NULL,
                                   categories = NULL,
                                   elements = NULL,
                                   ...) {

  fluid_cytology_ids <- c('XpRDEf5Qdsu', 'yHkftZnekcx', 'Lk9KZvx3xkW', 'ZIgUukxYsBF')
  data <- get_analytics(fluid_cytology_ids,
                        start_date = start_date,
                        end_date = end_date,
                        level = level,
                        organisations = organisations,
                        categories = categories,
                        elements = elements,
                        ...) %>%
    mutate(
      element = str_remove(element, 'MOH 706_'),
      element = factor(element),
      category = factor(category),
      source = 'MOH 706'
    )
  return(data)
}

get_lab_tissue_histology <- function(start_date,
                                     end_date = NULL,
                                     level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                     organisations = NULL,
                                     categories = NULL,
                                     elements = NULL,
                                     ...) {

  tissue_histology_ids <- c('STKvckAzWBC', 'Ve4Bx1HlduP', 'fPm8y3kLwCm', 'jb3J98XNMf9', 'XCE6FTv74je', 'YF7IYOXMhhY', 'B0HcImlSutL', 'prBXOC9GUGL', 'YAV1XpqKYSC', 'MqrMxnv7Dcb', 'a9CTvvPxK9R', 'D0J3E66OsML', 'AE7qXQRbwDf')
  data <- get_analytics(tissue_histology_ids,
                        start_date = start_date,
                        end_date = end_date,
                        level = level,
                        organisations = organisations,
                        categories = categories,
                        elements = elements,
                        ...) %>%
    mutate(
      element = str_remove(element, 'MOH 706 Rev 2020_'),
      element = factor(element),
      category = factor(category),
      source = 'MOH 706'
    )
  return(data)
}

get_lab_bone_marrow <- function(start_date,
                                end_date = NULL,
                                level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                organisations = NULL,
                                categories = NULL,
                                elements = NULL,
                                ...) {

  bone_marrow_ids <- c('v9ijehI8xrH', 'F667EB6ixiF')
  data <- get_analytics(bone_marrow_ids,
                        start_date = start_date,
                        end_date = end_date,
                        level = level,
                        organisations = organisations,
                        categories = categories,
                        elements = elements,
                        ...) %>%
    mutate(
      element = str_remove(element, 'MOH 706_ '),
      element = factor(element),
      category = factor(category),
      source = 'MOH 706'
    )
  return(data)
}

get_lab_fna <- function(start_date,
                        end_date = NULL,
                        level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                        organisations = NULL,
                        categories = NULL,
                        elements = NULL,
                        ...) {

  fna_ids <- c('X62FqsceLwy','a5Cl882MiWW','cxuDVZB2isV','WqDWu1qvPBy','EBgOiaKwudj')
  data <- get_analytics(fna_ids,
                        start_date = start_date,
                        end_date = end_date,
                        level = level,
                        organisations = organisations,
                        categories = categories,
                        elements = elements,
                        ...) %>%
    mutate(
      element = str_remove(element, 'MOH 706_ '),
      element = factor(element),
      category = factor(category),
      source = 'MOH 706'
    )
  return(data)
}

get_lab_smears <- function(start_date,
                           end_date = NULL,
                           level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                           organisations = NULL,
                           categories = NULL,
                           elements = NULL,
                           ...) {

  smears_ids <- c('OZXN2rx0yks','ENd9rOFnrFK','yovDbqQmVzR')
  data <- get_analytics(smears_ids,
                        start_date = start_date,
                        end_date = end_date,
                        level = level,
                        organisations = organisations,
                        categories = categories,
                        elements = elements,
                        ...) %>%
    mutate(
      element = str_remove(element, 'MOH 706_ '),
      element = factor(element),
      category = factor(category),
      source = 'MOH 706'
    )
  return(data)
}
