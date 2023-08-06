import { request } from './apiRequest';

export default {
  async getUsers(limit, offset) {
    try {
      const res = await request.get('/users', {
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
