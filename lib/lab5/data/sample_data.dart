import '../models/movie.dart';

final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Avatar: The Way of Water',
    posterUrl: 'https://image.tmdb.org/t/p/w500/t6TL73T76Hqy6g30E6VavCg4Y8g.jpg',
    overview: 'Jake Sully lives with his newfound family formed on the extraterrestrial moon of Pandora. Once a familiar threat returns to finish what was previously started, Jake must work with Neytiri and the army of the Na\'vi race to protect their home.',
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    rating: 8.7,
    trailers: ['Official Trailer 1', 'Teaser Trailer', 'Behind the Scenes'],
  ),
  Movie(
    id: 2,
    title: 'Spiderman: Into the Spider-Verse',
    posterUrl: 'https://image.tmdb.org/t/p/w500/iiZZ9wG8B7CLw9h2vSBNpaPd966.jpg',
    overview: 'Teen Miles Morales becomes the Spider-Man of his universe, and must join with five spider-powered individuals from other dimensions to stop a threat for all realities.',
    genres: ['Animation', 'Action', 'Adventure'],
    rating: 9.0,
    trailers: ['Teaser Trailer', 'Official Trailer 2'],
  ),
  Movie(
    id: 3,
    title: 'Interstellar',
    posterUrl: 'https://image.tmdb.org/t/p/w500/gEU2QG0wOhvK2g8gAlUGddvC9as.jpg',
    overview: 'The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.',
    genres: ['Sci-Fi', 'Drama', 'Adventure'],
    rating: 8.9,
    trailers: ['Official Trailer 1', 'Final Trailer'],
  ),
];