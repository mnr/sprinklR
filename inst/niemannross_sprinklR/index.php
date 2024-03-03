<?php

    $heartBeatFile = "heartbeat_data.json" ;
    $lastHeartBeat = filemtime($heartBeatFile) ;

    $json = file_get_contents($heartBeatFile);

    // Decode the JSON file
    $json_data = json_decode($json,true);
?>

<!doctype html>
<html>
  <head>
    <title>Status of Irrigation System</title>

    <div>
  <canvas id="myChart"></canvas>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
  const ctx = document.getElementById('myChart');

//'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'

  new Chart(ctx, {
    data: {
        labels: [<?php echo implode(", ", range(1,366)) ?>],
      datasets: [{
            type: 'line',
            label: 'Rainfall',
        data: [<?php echo implode(", ",$json_data["wbz_rainfall"]) ?>]

      }, {
          type: 'bar',
          label: 'Zone One needed',
          data: [<?php echo implode(", ",$json_data["wbz_NeededZone1"]) ?>]
      },{
          type: 'bar',
          label: 'Zone Two needed',
          data: [<?php echo implode(", ",$json_data["wbz_NeededZone2"]) ?>]
     },{
          type: 'line',
          label: 'Zone one watered',
          data: [<?php echo implode(", ",$json_data["wbz_WateredZone1"]) ?>]
      },{
          type: 'line',
          label: 'Zone Two watered',
          data: [<?php echo implode(", ",$json_data["wbz_WateredZone2"]) ?>]
     }]
    },
    options: {
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
  });
</script>

  </head>
  <body>

  <iframe src="https://github.com/sponsors/mnr/card" title="Sponsor mnr" height="225" width="600" style="border: 0;"></iframe>

    <p><?php echo "Last heartbeat: " . date("Y-m-d H:i:s", $lastHeartBeat)?></p>
    <p><?php echo "IP Address: " . $json_data["iam"] ?></p>
    <p><?php echo "Last Reboot: " . $json_data["last_reboot"] ?></p>
    <p><?php echo "Day of Year: " . (date("z") + 1) ?></p>

</body>
</html>
