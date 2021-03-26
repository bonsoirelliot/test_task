import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_task/models/shop_screen_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShopScreen extends StatelessWidget {
  ShopScreenModel model = new ShopScreenModel();
  var _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ShopScreenModel>(
      model: model,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Список товаров',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'ProximaNova',
                  fontWeight: FontWeight.bold)),
        ),
        child: ScopedModelDescendant<ShopScreenModel>(
          builder: (context, widget, child) => FutureBuilder(
            future: model.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return PageView.builder(
                  physics: !model.canSwipe
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
                  itemCount: model.pages_count,
                  itemBuilder: (context, position) {
                    return StaggeredGridView.countBuilder(
                      controller: _controller,
                      crossAxisCount: 2,
                      itemCount: model.item_count(position),
                      staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
                      mainAxisSpacing: 20,
                      itemBuilder: (context, i) {
                        _controller.addListener(() {
                          if (_controller.position.pixels ==
                              _controller.position.maxScrollExtent) {
                            model.setBoolTrue();
                          } else {
                            model.setBoolFalse();
                          }
                        });
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: CachedNetworkImage(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      snapshot.data[i + 6 * position].image,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                snapshot.data[i + 6 * position].article
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontFamily: 'ProximaNova'),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Center(
                              child: Text(
                                snapshot.data[i + 6 * position].name,
                                //softWrap: false,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'ProximaNova'),
                                //textAlign: TextAlign.left,
                                //overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Center(
                              child: Text(
                                NumberFormat.currency(locale: 'ru')
                                    .format(snapshot.data[i].price),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'ProximaNova',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
