<template>
  <div class="content">
    <hotel-form></hotel-form>
    <div
      class="md-layout-item md-medium-size-100 md-xsmall-size-100 md-size-100"
    >
      <md-card class="md-card-plain">
        <md-card-header data-background-color="green">
          <h4 class="title">Room</h4>
          <p class="category">Room in hotel</p>
        </md-card-header>
        <md-card-content>
          <room-table></room-table>
        </md-card-content>
      </md-card>
    </div>
  </div>
</template>
<script>
import { HotelForm, RoomTable } from "@/components";

export default {
  components: {
    HotelForm,
    RoomTable,
  },
};
</script>
<style lang=""></style>
