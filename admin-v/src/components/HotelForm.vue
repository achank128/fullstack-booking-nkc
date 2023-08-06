<template>
  <form @submit.prevent="submitFrom">
    <md-card>
      <md-card-header :data-background-color="dataBackgroundColor">
        <h4 class="title">{{ title }}</h4>
      </md-card-header>

      <md-card-content>
        <div class="md-layout">
          <div class="md-layout-item md-small-size-100 md-size-10">
            <md-field>
              <label>ID</label>
              <md-input v-model="hotelForm.MaKhachSan" disabled></md-input>
            </md-field>
          </div>
          <div class="md-layout-item md-small-size-100 md-size-90">
            <md-field>
              <label>Hotel Name</label>
              <md-input v-model="hotelForm.TenKhachSan" type="text"></md-input>
            </md-field>
          </div>
          <div class="md-layout-item md-small-size-100 md-size-100">
            <md-field>
              <label>Address</label>
              <md-input v-model="hotelForm.DiaChi" type="text"></md-input>
            </md-field>
          </div>
          <div class="md-layout-item md-small-size-100 md-size-20">
            <md-field>
              <label>Star</label>
              <md-input v-model="hotelForm.ChatLuong" type="number"></md-input>
            </md-field>
          </div>
          <div class="md-layout-item md-small-size-100 md-size-20">
            <md-field>
              <label>Review</label>
              <md-input v-model="hotelForm.DanhGia" type="number"></md-input>
            </md-field>
          </div>
          <div class="md-layout-item md-small-size-100 md-size-20">
            <md-field>
              <label>Number of Reviews</label>
              <md-input v-model="hotelForm.SoDanhGia" type="number"></md-input>
            </md-field>
          </div>
          <div class="md-layout-item md-small-size-100 md-size-20">
            <md-field>
              <label>PositionID</label>
              <md-input v-model="hotelForm.MaDiaDiem" type="text"></md-input>
            </md-field>
          </div>
          <div class="md-layout-item md-small-size-100 md-size-20">
            <md-field>
              <label>TypeID</label>
              <md-input v-model="hotelForm.MaLoai" type="text"></md-input>
            </md-field>
          </div>
          <div class="md-layout-item md-small-size-100 md-size-100">
            <md-field>
              <label>Image Address</label>
              <md-input v-model="hotelForm.Anh" type="text"></md-input>
            </md-field>
          </div>
          <div class="md-layout-item md-size-100">
            <md-field maxlength="5">
              <label>Description</label>
              <md-textarea v-model="hotelForm.MoTa"></md-textarea>
            </md-field>
          </div>
          <div class="md-layout-item md-size-100 text-right">
            <md-button type="submit" class="md-raised md-success"
              >Save</md-button
            >
          </div>
        </div>
      </md-card-content>
    </md-card>
  </form>
</template>
<script>
import { request } from "../services/apiRequest";
import store from "../store";

export default {
  name: "hotel-form",
  props: {
    dataBackgroundColor: {
      type: String,
      default: "green",
    },
  },
  data() {
    return {
      title: "Add Hotel",
      hotelForm: {
        MaKhachSan: null,
        TenKhachSan: null,
        ChatLuong: null,
        DanhGia: null,
        SoDanhGia: null,
        DiaChi: null,
        Anh: null,
        MaLoai: null,
        MoTa: null,
        MaDiaDiem: null,
      },
    };
  },
  methods: {
    async getHotel(id) {
      try {
        const res = await request.get("/hotels/" + id);
        this.hotelForm = res.data.data;
      } catch (error) {
        console.log(error);
      }
    },
    submitFrom() {
      this.$router.push("/hotels");
    },
  },
  mounted() {
    if (this.$route.params.id) {
      store.state.hotelId = this.$route.params.id;
      this.title = "Edit Hotel";
      this.getHotel(this.$route.params.id);
    }
  },
};
</script>
<style></style>
