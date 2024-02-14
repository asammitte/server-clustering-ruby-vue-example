module Api
  class MapController < ApplicationController

    
    def index

      swLon = params["swLon"] || -180
      neLat = params["neLat"] || 90
      swLat = params["swLat"] || -90
      neLon = params["neLon"] || 180
      zoom = params["zoom"].to_i || 0

      # fetching crags which are not in area from ES
      res = Crag.crags_out_area(neLat, swLon, swLat, neLon)
      
      # default zoom level for H3 indexes
      resolution = 4

      # depending on map zoom we decide which H3 resolution we will be using
      if zoom < 4
        resolution = 1
      elsif zoom == 4
        resolution = 2
      elsif zoom == 5
        resolution = 3
      elsif zoom == 6
        resolution = 4
      elsif zoom == 7
        resolution = 5
      elsif zoom == 8
        resolution = 6
      elsif zoom == 9
        resolution = 7
      elsif zoom == 10
        resolution = 8
      else
        resolution = 9
      end

      # array for crags with H3 indexes
      cragsWithH3Index = Array.new

      # assign H3 indexe for each location
      res.response['hits']['hits'].each do |document|
        crag = document._source
        h3Index = H3.from_geo_coordinates([crag.location.lat, crag.location.lon], resolution).to_s(16)
        cragsWithH3Index.push(CragWithH3.new h3Index, crag.cragName, crag.cragSlug, crag.location.lat, crag.location.lon)
      end

      # group crags by h3Indexes
      # each group represents crags which belong to same H3 index
      groupedCrags = cragsWithH3Index.group_by { |c| c.h3Index }

      features = []


      # here we will create GeoJSON features
      #
      # if group has only one item, then in this area we have only one crag
      # and then we will sent it as pointFeature which will contain
      # crag name and crag slug and exact GeoLocation lat lon
      #
      # if group has more then one crag then this will be a server cluster
      # with server cluster we can get H3 cell center point
      # which will lead to "chess like" positioning of cluster points on the map
      # or we can calculate average GeoLocation from all the points in this group
      groupedCrags.each do |group|
        if group[1].length() <= 1
          cragInfo = group[1][0]
          # feature = RGeo::GeoJSON::Feature.new(point, id = group[0], properties = { "cragName" => cragInfo.cragName, "cragSlug" => cragInfo.cragSlug})
          # features.push(feature)
          features << pointFeature(cragInfo.lat, cragInfo.lon, cragInfo.cragName, cragInfo.cragSlug)
        else
          # uncomment this block and comment next one
          # if you want to achieve average center for each cell
          # calculate average center for each cluster
          # to avoid perfect "chess like" positioning of clusters
          # so this would look more real
          # -- BLOCK START --
          # lats = group[1].map{|obj| obj.lat}
          # avgLat = average(lats)
          # lons = group[1].map{|obj| obj.lon}
          # avgLon = average(lons)
          # features << clusterFeature(avgLat, avgLon, group[1].length)
          # -- BLOCK END --
          
          # H3 centers "chess like" positioning
          # -- BLOCK START --
          coords = H3.to_geo_coordinates(group[0].to_i(16))
          puts coords[0]
          features << clusterFeature(coords[0], coords[1], group[1].length)
          # -- BLOCK END --
        end
      end

      featureCollection = RGeo::GeoJSON::FeatureCollection.new(features)
      
      render json: RGeo::GeoJSON.encode(featureCollection)
    end


    def average(array)
      sum = 0
      array.each do |element|
        sum += element
      end
      average = sum.to_f / array.length
      return average
    end
    
    def clusterFeature(lat, lon, amount)
      factory = RGeo::Cartesian.simple_factory(srid: 4326)
      point = factory.point(lon, lat)
      feature = RGeo::GeoJSON::Feature.new(point, id = nil, properties = {"amount": amount})
      return feature
    end
    
    def pointFeature(lat, lon, name, slug)
      factory = RGeo::Cartesian.simple_factory(srid: 4326)
      point = factory.point(lon, lat)
      feature = RGeo::GeoJSON::Feature.new(point, id = nil, properties = {"name": name, "slug": slug})
      return feature
    end

  end
end


class CragWithH3
  attr_accessor :h3Index, :cragName, :cragSlug, :lat, :lon
  attr_reader :h3Index

  def initialize(h3Index, cragName, cragSlug, lat, lon)
    @h3Index = h3Index
    @cragName = cragName
    @cragSlug = cragSlug
    @lat = lat
    @lon = lon
  end
end

class FeatureCollection
  def initialize(features)
    @type = 'FeatureCollection'
    @features = features
  end
end