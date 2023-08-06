<template>
  <div class="content">
    <md-table v-model="rooms" :table-header-color="tableHeaderColor">
      <md-table-row slot="md-table-row" slot-scope="{ item }">
        <md-table-cell md-label="ID">{{ item.MaLoaiPhong }}</md-table-cell>
        <md-table-cell md-label="Name">{{ item.TenLoaiPhong }}</md-table-cell>
        <md-table-cell md-label="Bed">{{ item.SoGiuong }}</md-table-cell>
        <md-table-cell md-label="People">{{ item.SoNguoi }}</md-table-cell>
        <md-table-cell md-label="Price">{{ item.GiaPhong }}</md-table-cell>
        <md-table-cell md-label="Description">
          {{ item.MoTa.slice(0, 50) }}...
        </md-table-cell>
      </md-table-row>
    </md-table>
  </div>
</template>

<script>
import hotelService from "../services/hotelService";
import store from "../store";

export default {
  name: "room-table",
  props: {
    tableHeaderColor: {
      type: String,
      default: "",
    },
    hotelId: {
      type: String,
    },
  },
  data() {
    return {
      selected: [],
      rooms: [],
    };
  },
  methods: {
    async getHotelsData() {
      const hotelsData = await hotelService.getHotelRooms(store.state.hotelId);
      this.rooms = hotelsData.data;
    },
  },
  mounted() {
    this.getHotelsData();
  },
};
</script>
