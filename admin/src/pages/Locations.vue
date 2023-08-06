<template>
  <div class="content">
    <md-button to="/locations/add-location" class="md-success btn-add-hotel"
      >Add Location</md-button
    >
    <div class="md-layout-item">
      <md-card>
        <md-card-header data-background-color="green">
          <h4 class="title">Locations List</h4>
          <p class="category">Locations in Booking.nkc</p>
        </md-card-header>
        <md-card-content>
          <location-table table-header-color="green"></location-table>
        </md-card-content>
      </md-card>
    </div>
  </div>
</template>

<script>
import { LocationTable } from "@/components";

export default {
  components: {
    LocationTable,
  },
};
</script>

<style>
.btn-add-hotel {
  float: right;
}
</style>
