<template>
  <div class="content">
    <md-table v-model="hotels" :table-header-color="tableHeaderColor">
      <md-table-row slot="md-table-row" slot-scope="{ item }">
        <md-table-cell md-label="ID">{{ item.MaKhachSan }}</md-table-cell>
        <md-table-cell md-label="Name">{{ item.TenKhachSan }}</md-table-cell>
        <md-table-cell md-label="Address">{{ item.DiaChi }}</md-table-cell>
        <md-table-cell md-label="Type">{{ item.MaLoai }}</md-table-cell>
        <md-table-cell md-label="Description">
          {{ item.MoTa.slice(0, 50) }}...
        </md-table-cell>
        <md-table-cell md-label="Star">{{ item.ChatLuong }}</md-table-cell>
        <md-table-cell md-label="Actions">
          <md-button
            class="md-just-icon md-simple md-primary"
            :to="`/hotels/edit-hotel/${item.MaKhachSan}`"
          >
            <md-icon>edit</md-icon>
            <md-tooltip md-direction="top">Edit</md-tooltip>
          </md-button>
          <md-button
            class="md-just-icon md-simple md-danger"
            @click="deleteHotel(item.MaKhachSan)"
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
import hotelService from '../services/hotelService';

export default {
  name: 'hotels-table',
  props: {
    tableHeaderColor: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      selected: [],
      hotels: [],
      limit: 10,
      currentPage: 1,
      total: 0,
    };
  },
  methods: {
    async getHotelsData() {
      const hotelsData = await hotelService.getHotels(
        this.limit,
        this.limit * (this.currentPage - 1)
      );
      this.hotels = hotelsData.data;
      this.total = hotelsData.meta.total;
    },

    deleteHotel(id) {
      this.hotels = this.hotels.filter((h) => h.MaKhachSan != id);
    },
  },
  watch: {
    limit() {
      this.getHotelsData();
    },
    currentPage() {
      this.getHotelsData();
    },
  },
  mounted() {
    this.getHotelsData();
  },
};
</script>

<style>
.pagination {
  text-align: center;
}
</style>
