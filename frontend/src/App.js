import { BrowserRouter, Routes, Route } from "react-router-dom";
import "./App.scss";
import Home from "./pages/home/Home";
import Hotel from "./pages/hotel/Hotel";
import ListHotel from "./pages/listHotel/ListHotel";
import Login from "./pages/login/Login";
import Register from "./pages/register/Register";
import Book from "./pages/book/Book";
import Booked from "./pages/booked/Booked";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/hotels" element={<ListHotel />} />
        <Route path="/hotels/:id" element={<Hotel />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/book/:id" element={<Book />} />
        <Route path="/booked" element={<Booked />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
