<template>
  <div class="content">
    <md-button to="/locations/add-location" class="md-success btn-add-hotel"
      >Add User</md-button
    >
    <div class="md-layout-item">
      <md-card>
        <md-card-header data-background-color="green">
          <h4 class="title">User List</h4>
          <p class="category">Users in Booking.nkc</p>
        </md-card-header>
        <md-card-content>
          <user-table table-header-color="green"></user-table>
        </md-card-content>
      </md-card>
    </div>
  </div>
</template>

<script>
import { UserTable } from '@/components';

export default {
  components: {
    UserTable,
  },
};
</script>

<style>
.btn-add-hotel {
  float: right;
}
</style>
