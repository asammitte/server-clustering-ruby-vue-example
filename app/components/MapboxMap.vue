<template>
  <div ref="mapContainer" class="map-container"></div>
</template>

<script>
import mapboxgl from "mapbox-gl";

export default {
  data() {
    return {
      map: null
    }
  },
  mounted() {
    this.initialiseMap()
  },
  unmounted() {
    this.map.remove()
    this.map = null
  },
  methods: {
    initialiseMap() {
      mapboxgl.accessToken = this.$config.NUXT_PUBLIC_MAPBOX_ACCESS_TOKEN
      const map = new mapboxgl.Map({
        container: this.$refs.mapContainer,
        style: "mapbox://styles/mapbox/streets-v12", // Replace with your preferred map style
        center: [1.675063, 47.751569],
        zoom: 6,
      })

      const controls = new mapboxgl.NavigationControl({
        showZoom: true,
        showCompass: false
      })
      
      map.addControl(controls)

      map.on('moveend', async () => {
        await this.requestData()
      })

      this.map = map;
    },
    async requestData() {
      const swlat = this.map.getBounds().getSouthWest().lat;
      const swlng = this.map.getBounds().getSouthWest().lng;
      const nelat = this.map.getBounds().getNorthEast().lat;
      const nelng = this.map.getBounds().getNorthEast().lng;
      const zoom = Math.round(this.map.getZoom());
      const resolution = 4;


      if (this.map.getLayer('cragsLayer')) this.map.removeLayer('cragsLayer')
      if (this.map.getLayer('cragsCountLayer')) this.map.removeLayer('cragsCountLayer')
      if (this.map.getLayer('unclasteredCragsOutAreaLayer')) this.map.removeLayer('unclasteredCragsOutAreaLayer')
      if (this.map.getSource('serverCusters')) this.map.removeSource('serverCusters')


      await this.$axios
        .$get(`/api/map?zoom=${zoom}&resolution=${resolution}&swlat=${swlat}&swlon=${swlng}&nelat=${nelat}&nelon=${nelng}`)
        .then(res => {
          this.map.addSource('serverCusters', {
            type: 'geojson',
            data: res,
          })

        // this.map.addLayer({
        //   'id': `polygons`,
        //   'type': 'fill',
        //   'source': `crags_${swlat}`,
        //   'paint': {
        //     'fill-opacity': 0.2,
        //     'fill-outline-color': 'red'
        //   }
        // });


        // // Add a black outline around the polygon.
        // this.map.addLayer({
        //   'id': 'outline',
        //   'type': 'line',
        //   'source': `crags_${swlat}`,
        //   'layout': {},
        //   'paint': {
        //     'line-color': '#000',
        //     'line-width': 1
        //   }
        // });


        // Add crags points
        this.map.addLayer({
          'id': 'cragsLayer',
          'type': 'circle',
          'source': 'serverCusters',
          'paint': {
            'circle-radius': [
              'step',
              ['get', 'amount'],
              8, 10,
              9, 20,
              10
            ],
            'circle-stroke-width': 0.8,
            'circle-color': 'blue',
            'circle-stroke-color': '#e3e3dd'
          },
          filter: ['has', 'amount'],
        })

        this.map.addLayer({
          id: 'cragsCountLayer',
          type: 'symbol',
          source: 'serverCusters',
          filter: ['has', 'amount'],
          layout: {
            'text-field': ['get', 'amount'],
            'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
            'text-size': 12,
          },
          paint: {
            "text-color": "#ffffff"
          }
        })


        this.map.addLayer({
          id: 'unclasteredCragsOutAreaLayer',
          type: 'circle',
          source: 'serverCusters',
          filter: ['has', 'name'],
          paint: {
            'circle-radius': 6,
            'circle-stroke-width': 2,
            'circle-color': 'red',
            'circle-stroke-color': '#e3e3dd'
          },
        })
      })
    }
  }
}
</script>

<style>
.map-container {
  flex: 1;
}
</style>
