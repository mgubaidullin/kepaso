import 'kepaso_client.dart';

class LeftMenu extends StatelessWidget {
  Widget build(BuildContext context) {

    return GetBuilder<SourceController>(
        builder: (sourceController) => sourceController.sources.isEmpty ? Container() : _getMenu(context, sourceController)
    );
  }

  Widget _getMenu(BuildContext context, SourceController sourceController){
    var screenSize = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(top: 10.0),
    width: screenSize.width > 1200 ? 290.0 : 200,
    decoration: BoxDecoration(color: LEFT_MENU, border: Border(bottom: BorderSide(width: 2.0, color: LEFT_MENU_SELECTED))),
    child:ListView.separated(
      padding: EdgeInsets.all(0.0),
      separatorBuilder: (context, index) => Divider(color: LEFT_MENU_SELECTED, thickness: 1, height: 0.0),
      itemCount: sourceController.sources.length + 2,
      itemBuilder: (context, index) {
        if (index == 0 || index == sourceController.sources.length + 1) {
          return Container(); // zero height: not visible
        }
        final item = sourceController.sources.keys.toList()[index - 1];
        final selected = sourceController.selectedSource.value == item;
        return Row(children: [
          Expanded(
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.all(0.0),
                    height: 56.0,
                    decoration: BoxDecoration(
                        color: selected ? LEFT_MENU_SELECTED : LEFT_MENU,
                        border: Border(left: BorderSide(width: 4.0, color: selected ? BLUE : Colors.transparent))
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item, style: MENU),
                        ))),
                onTap: () => sourceController.select(item),
              ))
        ]);
      },
    ));
  }
}
