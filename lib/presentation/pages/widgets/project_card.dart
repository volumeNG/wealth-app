import 'package:flutter/cupertino.dart';
import 'package:wealth/presentation/pages/widgets/project_desc.dart';


//This is the project card
class ProjectCard extends StatefulWidget {
  const ProjectCard({Key? key}) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ProjectDescText(
            width: width,
            location: "Abuja, Nigeria",
            property: "Thoronto House Garden",
            fundRaised: 450000000,
            targetFund: 500000000),
      ],
    );
  }
}
