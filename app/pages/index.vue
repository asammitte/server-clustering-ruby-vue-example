<template>
  <div class="map-page">
    <div>Red dot - single crag</div>
    <div>Blue dot - server clustered dot</div>
    <div class="map-block">
      <mapbox-map />
    </div>
  </div>
</template>

<script>
import MapboxMap from '@/components/MapboxMap.vue'
import "../node_modules/mapbox-gl/dist/mapbox-gl.css"

export default {
    name: 'IndexPage',
    // comments: {
    //     MapboxMap
    // },
    components: { MapboxMap }
}
</script>

<style>
.map-block {
  position: relative;
  display: flex;
  height: calc(100vh - 60px);
  padding: 0;
  flex: 1;
}

@media (min-width: 1024px) {
  .map-block {
    display: flex;
    height: calc(100vh - 60px);
    padding: 0;
    flex: 1;
  }
}
</style>
