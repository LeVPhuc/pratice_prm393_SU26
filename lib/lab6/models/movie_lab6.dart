class MovieLab6 {
  final String title;
  final String posterUrl;
  final String genre;
  final double rating;
  final int year;

  MovieLab6({
    required this.title,
    required this.posterUrl,
    required this.genre,
    required this.rating,
    required this.year,
  });
}

// Danh sách dữ liệu mẫu đa dạng để test tính năng Lọc và Sắp xếp
final List<MovieLab6> sampleMoviesLab6 = [
  MovieLab6(
    title: 'Avatar: The Way of Water',
    posterUrl: 'https://image.tmdb.org/t/p/w500/t6TL73T76Hqy6g30E6VavCg4Y8g.jpg',
    genre: 'Action',
    rating: 7.8,
    year: 2022,
  ),
  MovieLab6(
    title: 'Spiderman: Into the Spider-Verse',
    posterUrl: 'https://image.tmdb.org/t/p/w500/iiZZ9wG8B7CLw9h2vSBNpaPd966.jpg',
    genre: 'Animation',
    rating: 8.4,
    year: 2018,
  ),
  MovieLab6(
    title: 'Interstellar',
    posterUrl: 'https://image.tmdb.org/t/p/w500/gEU2QG0wOhvK2g8gAlUGddvC9as.jpg',
    genre: 'Sci-Fi',
    rating: 8.7,
    year: 2014,
  ),
  MovieLab6(
    title: 'The Dark Knight',
    posterUrl: 'https://image.tmdb.org/t/p/w500/qJ2tWw751O32jZmgjclvGPh5mZz.jpg',
    genre: 'Action',
    rating: 9.0,
    year: 2008,
  ),
  MovieLab6(
    title: 'The Hangover',
    posterUrl: 'https://image.tmdb.org/t/p/w500/isg070UvR9bY3bY1N3j60gC59b2.jpg',
    genre: 'Comedy',
    rating: 7.7,
    year: 2009,
  ),
];