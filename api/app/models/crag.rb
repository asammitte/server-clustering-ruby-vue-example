class Crag < ApplicationRecord
  include Elasticsearch::Model

  index_name "8a_beta_crags"

  def self.crags_out_area(neLat, swLon, swLat, neLon)
    search(
      size: 10000,
      query: {
        bool: {
          must:[
            {
              geo_bounding_box: {
                location: {
                  top_left: {
                    lat: neLat,
                    lon: swLon
                  },
                  bottom_right: {
                    lat: swLat,
                    lon: neLon
                  }
                }
              }
            },
            {
              exists: {
                field: "location"
              }
            }
          ],
          must_not: [
            {
              exists: {
                field: "areaId"
              }
            }
          ]
        }
      },
      _source: ["cragName", "cragSlug", "location"]
    )
  end
end

# ,"size":10000,"sort":[{"statistics.totalAscents":{"order":"desc"}}]