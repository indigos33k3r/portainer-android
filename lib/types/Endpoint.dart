import '../main.dart';
import 'DContainer.dart';
import 'Image.dart';
import 'Volume.dart';

class Endpoint {
  final int id;
  final String name;
  final int type;
  final int statusNum;
  final int runningContainers;
  final int stoppedContainers;
  final int imageCount;
  final int volumeCount;
  int get containerCount => runningContainers + stoppedContainers;

  String get containersStatus => runningContainers.toString() + '/' + containerCount.toString() + ' running';
  String get status => statusNum == 1 ? "up" : "down";

  Future<List<DContainer>> getContainers() async {
    if (containers != null) return containers;
    final _response = await MyApp.api.get('/api/endpoints/$id/docker/containers/json?all=1');
    print(_response[0]);
    containers = [];
    (_response as List<dynamic>)
      .map((container) => DContainer.fromJson(this, container))
      .forEach((container) => containers.add(container));
    return containers;
  }

  Future<List<DImage>> getImages() async {
    if (images != null) return images;
    final _response = await MyApp.api.get('/api/endpoints/$id/docker/images/json');
    print(_response[0]);
    images = [];
    (_response as List<dynamic>)
      .map((image) => DImage.fromJson(this, image))
      .forEach((image) => images.add(image));
    return images;
  }

  List<DContainer> containers;
  List<DImage> images;
  List<Volume> volumes;

  Endpoint(
    this.id,
    this.name,
    this.type,
    this.statusNum,
    this.runningContainers,
    this.stoppedContainers,
    this.imageCount,
    this.volumeCount
  );

  factory Endpoint.fromJson(Map<String, dynamic> json) {
    return Endpoint(
      json['Id'], 
      json['Name'],
      json['Type'],
      json['Status'],
      json['Snapshots'][0]['RunningContainerCount'],
      json['Snapshots'][0]['StoppedContainerCount'],
      json['Snapshots'][0]['ImageCount'],
      json['Snapshots'][0]['VolumeCount']
    );
  }
}