<template>
  <div class="content">
    <md-button to="/hotels/add-hotel" class="md-success btn-add-hotel"
      >Add Hotel</md-button
    >
    <div class="md-layout-item">
      <md-card>
        <md-card-header data-background-color="green">
          <h4 class="title">Hotels List</h4>
          <p class="category">Hotel in Booking.nkc</p>
        </md-card-header>
        <md-card-content>
          <hotel-table table-header-color="green"></hotel-table>
        </md-card-content>
      </md-card>
    </div>
  </div>
</template>

<script>
import { HotelTable } from "@/components";

export default {
  components: {
    HotelTable,
  },
};
</script>

<style>
.btn-add-hotel {
  float: right;
}
</style>
