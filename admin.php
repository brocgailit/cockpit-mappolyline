<?php

$app->on('admin.init', function () {
  $this->helper('admin')->addAssets('mappolyline:assets/field-map-polyline.tag');
});