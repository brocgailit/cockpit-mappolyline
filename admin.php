<?php

$app->on('admin.init', function () {
  $this->helper('admin')->addAssets('fetchautocomplete:assets/field-map-polyline.tag');
});