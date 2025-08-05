
export class DashboardTopConstant {
  // Banner Chart Customers
  public static bannerChartLabelCustomers = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEPT', 'OCT', 'NOV', 'DEC'];
  public static bannerChartOptionsCustomers = {
    responsive: true,

    legend: {
      display: false,
      position: 'top',
      labels: {
        // usePointStyle: true
      }
    },
    scales: {
      xAxes: [
        {
          display: false,
          gridLines: {
            display: false,
            drawBorder: false
          },
          scaleLabel: {
            display: false,
            labelString: 'string'
          }
        }
      ],
      yAxes: [
        {
          display: false,
          gridLines: {
            display: false,
            drawBorder: false
          },
          scaleLabel: {
            // display: true,
            labelString: 'Value'
          }
        }
      ]
    },
    title: {
      display: false
    }
  };
  public static bannerChartDataCustomers = [
    {
      data: [280, 220, 100, 250, 350, 400, 300, 100, 250, 350, 400, 300],
      backgroundColor: 'rgba(255,164,34,0.32)',
      borderColor: '#F4A52E',
      borderWidth: 3,
      strokeColor: '#F4A52E',
      capBezierPoints: !0,
      pointColor: '#F4A52E',
      pointBorderColor: '#F4A52E',
      pointBackgroundColor: '#F4A52E',
      pointBorderWidth: 3,
      pointRadius: 6,
      pointHoverBackgroundColor: '#F4A52E',
      pointHoverBorderColor: '#F4A52E',
      pointHoverRadius: 10
    }
  ];

  // Banner Chart Providers
  public static bannerChartLabelsProviders = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEPT', 'OCT', 'NOV', 'DEC'];
  public static bannerChartOptionsProviders = {
    responsive: true,
    tooltips: {
      enabled: true
    },
    legend: {
      display: false,
      position: 'top',
      labels: {
        usePointStyle: true
      }
    },
    scales: {
      xAxes: [
        {
          display: false,
          gridLines: {
            display: false,
            drawBorder: false
          },
          scaleLabel: {
            display: false,
            labelString: 'string'
          }
        }
      ],
      yAxes: [
        {
          display: false,
          gridLines: {
            display: false,
            drawBorder: false
          },
          scaleLabel: {
            display: true,
            labelString: 'Value'
          }
        }
      ]
    },
    title: {
      display: false
    }
  };
  public static bannerChartDataProviders = [
    {
      data: [28, 35, 36, 48, 46, 42, 60, 36, 48, 46, 42, 60],
      backgroundColor: 'rgba(0,175,240,0.32)',
      borderColor: '#50AAED',
      borderWidth: 3,
      strokeColor: '#50AAED',
      capBezierPoints: !0,
      pointColor: '#50AAED',
      pointBorderColor: '#50AAED',
      pointBackgroundColor: '#50AAED',
      pointBorderWidth: 3,
      pointRadius: 6,
      pointHoverBackgroundColor: '#50AAED',
      pointHoverBorderColor: '#50AAED',
      pointHoverRadius: 10
    }
  ];

  // Banner chart Orders
  public static bannerChartOrders = {
    responsive: true,
    tooltips: {
      enabled: true
    },
    legend: {
      display: false,
      position: 'top',
      labels: {
        usePointStyle: true
      }
    },
    scales: {
      xAxes: [
        {
          display: false,
          gridLines: {
            display: false,
            drawBorder: false
          },
          scaleLabel: {
            display: false,
            labelString: 'string'
          }
        }
      ],
      yAxes: [
        {
          display: false,
          gridLines: {
            display: false,
            drawBorder: false
          },
          scaleLabel: {
            display: true,
            labelString: 'Value'
          }
        }
      ]
    },
    title: {
      display: false
    }
  };

  public static bannerChartLabelsOrders = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEPT', 'OCT', 'NOV', 'DEC'];
  public static bannerChartDataOrders = [
    {
      data: [28, 35, 36, 48, 46, 42, 60, 36, 48, 46, 42, 60],
      backgroundColor: 'rgba(156,39,176,0.32)',
      borderColor: '#A668FD',
      borderWidth: 3,
      strokeColor: '#A668FD',
      capBezierPoints: !0,
      pointColor: '#A668FD',
      pointBorderColor: '#A668FD',
      pointBackgroundColor: '#A668FD',
      pointBorderWidth: 3,
      pointRadius: 6,
      pointHoverBackgroundColor: '#A668FD',
      pointHoverBorderColor: '#A668FD',
      pointHoverRadius: 10
    }
  ];

  // Banner chart Revenue
  public static bannerChartRevenue = {
    responsive: true,
    tooltips: {
      enabled: true
    },
    legend: {
      display: false,
      position: 'top',
      labels: {
        usePointStyle: true
      }
    },
    scales: {
      xAxes: [
        {
          display: false,
          gridLines: {
            display: false,
            drawBorder: false
          },
          scaleLabel: {
            display: false,
            labelString: 'string'
          }
        }
      ],
      yAxes: [
        {
          display: false,
          gridLines: {
            display: false,
            drawBorder: false
          },
          scaleLabel: {
            display: true,
            labelString: 'Value'
          }
        }
      ]
    },
    title: {
      display: false
    }
  };
  public static bannerChartLabelsRevenue = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEPT', 'OCT', 'NOV', 'DEC'];
  public static bannerChartDataRevenue = [
    {
      data: [28, 35, 36, 48, 46, 42, 60, 36, 48, 46, 42, 60],
      backgroundColor: 'rgba(113,216,117,0.32)',
      borderColor: '#77DC77',
      borderWidth: 3,
      strokeColor: '#77DC77',
      // capBezierPoints: !0,
      pointColor: '#77DC77',
      pointBorderColor: '#77DC77',
      pointBackgroundColor: '#77DC77',
      pointBorderWidth: 3,
      pointRadius: 6,
      pointHoverBackgroundColor: '#77DC77',
      pointHoverBorderColor: '#77DC77',
      pointHoverRadius: 10
    }
  ];
}
