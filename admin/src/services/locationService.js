import { request } from "./apiRequest";

export default {
  async getLocations(limit, offset) {
    try {
      const res = await request.get("/locations", {
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
};
