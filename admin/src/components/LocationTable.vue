<template>
  <div class="content">
    <md-table v-model="locations" :table-header-color="tableHeaderColor">
      <md-table-row slot="md-table-row" slot-scope="{ item }">
        <md-table-cell md-label="ID">{{ item.MaDiaDiem }}</md-table-cell>
        <md-table-cell md-label="Name">{{ item.TenDiaDiem }}</md-table-cell>
        <md-table-cell md-label="Type">{{ item.LoaiDiaDiem }}</md-table-cell>
        <md-table-cell md-label="Image">
          <img :src="item.Anh" alt="Image" :style="{ width: '50px' }" />
        </md-table-cell>
        <md-table-cell md-label="Actions">
          <md-button
            class="md-just-icon md-simple md-primary"
            :to="`/locations/edit-hotel/${item.MaDiaDiem}`"
          >
            <md-icon>edit</md-icon>
            <md-tooltip md-direction="top">Edit</md-tooltip>
          </md-button>
          <md-button
            class="md-just-icon md-simple md-danger"
            @click="deleteLocation(item.MaDiaDiem)"
          >
            <md-icon>close</md-icon>
            <md-tooltip md-direction="top">Delete</md-tooltip>
          </md-button>
        </md-table-cell>
      </md-table-row>
    </md-table>
    <div class="pagination">
      <md-button
        class="md-simple md-just-icon"
        v-if="currentPage > 1"
        @click="() => (currentPage = 1)"
      >
        <md-icon>keyboard_double_arrow_left</md-icon>
      </md-button>
      <md-button @click="() => currentPage--" class="md-simple md-just-icon">
        <md-icon>navigate_before</md-icon>
      </md-button>
      <md-button class="md-simple">{{ currentPage }}</md-button>
      <md-button class="md-simple md-just-icon" @click="() => currentPage++">
        <md-icon>navigate_next</md-icon>
      </md-button>
      <md-button
        v-if="currentPage <= Math.floor(total / limit)"
        @click="() => (currentPage = Math.floor(total / limit) + 1)"
        class="md-simple md-just-icon"
      >
        <md-icon>keyboard_double_arrow_right</md-icon>
      </md-button>
    </div>
  </div>
</template>

<script>
import locationService from "../services/locationService";

export default {
  name: "location-table",
  props: {
    tableHeaderColor: {
      type: String,
      default: "",
    },
  },
  data() {
    return {
      selected: [],
      locations: [],
      limit: 10,
      currentPage: 1,
      total: 0,
    };
  },
  methods: {
    async getLocationsData() {
      const locationsData = await locationService.getLocations(
        this.limit,
        this.limit * (this.currentPage - 1)
      );
      this.locations = locationsData.data;
      this.total = locationsData.meta.total;
    },

    deleteLocation(id) {
      this.locations = this.locations.filter((h) => h.MaDiaDiem != id);
    },
  },
  watch: {
    limit() {
      this.getLocationsData();
    },
    currentPage() {
      this.getLocationsData();
    },
  },
  mounted() {
    this.getLocationsData();
  },
};
</script>

<style>
.pagination {
  text-align: center;
}
</style>
