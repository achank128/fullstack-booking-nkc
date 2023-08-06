import { request } from "./apiRequest";

export default {
  async getHotels(limit, offset) {
    try {
      const res = await request.get("/hotels", {
        params: {
          limit,
          offset,
        },
      });
      return res.data;
    } catch (error) {
      console.log(error);
    }
  },
  async getHotelRooms(id) {
    try {
      const res = await request.get("/hotels/room/" + id);
      return res.data;
    } catch (error) {
      console.log(error);
    }
  },
};
