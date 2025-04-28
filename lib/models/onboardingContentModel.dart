class OnBoardingContent {
  String image;
  String title;
  String discription;

  OnBoardingContent({
    required this.title,
    required this.image,
    required this.discription,
  });
}

List<OnBoardingContent> contents =[
  OnBoardingContent(
      title: 'Ask me Anything',
      image: 'assets/lottie_files/on_boardAnimation1.json',
      discription: 'I can be your best Friend & you can ask me anything & I will help you!'
  ),
  OnBoardingContent(
      title: 'AI Image Generator',
      image: 'assets/lottie_files/on_boardAnimation2.json',
      discription: 'I can be your best Friend & you can ask me anything & I will help you build image generation!'
  ),
  OnBoardingContent(
      title: 'Movie Generator',
      image: 'assets/lottie_files/on_boardAnimation3.json',
      discription: 'I can be your best Friend & you can ask me anything & I will help you to build movie/clips generation !'
  )
];
