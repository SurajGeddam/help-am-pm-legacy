
import { Injectable } from '@angular/core';
import { HttpService } from '../core/service/http.service';

@Injectable()
export class DashboardService {

  constructor(private httpClient: HttpService) {

  }

  getAllCustomerCount() {
    return this.httpClient.get("dashboard/count/customers");
  }
  getAllProvidersCount() {
    return this.httpClient.get("dashboard/count/providers");
  }
  getAllQuotes() {
    return this.httpClient.get("dashboard/count/quotes");
  }
  getLatestQuotes() {
    return this.httpClient.get("dashboard/quotes/latest");
  }
  getLatestProviderQuotes() {
    return this.httpClient.get("dashboard/provider/quotes/latest");
  }

  getTotalEarnings() {
    return this.httpClient.get("dashboard/count/earnings");
  }

  getEarningsByDuration(startDate, endDate) {
    return this.httpClient.get(`dashboard/count/earnings-by-duration?startDate=${startDate}&endDate=${endDate}`);
  }

  getQuotesByDuration(startDate, endDate) {
    return this.httpClient.get(`dashboard/count/quotes-by-duration?startDate=${startDate}&endDate=${endDate}`);
  }

  getCustomersByDuration(startDate, endDate) {
    return this.httpClient.get(`dashboard/count/customers-signup-by-duration?startDate=${startDate}&endDate=${endDate}`);
  }
  getLatestReviews() {
    return this.httpClient.get("dashboard/reviews/latest");
  }
  getLatestProviderReviews(providerUniqueId) {
    return this.httpClient.get(`review/provider/${providerUniqueId}/received`);
  }

  getSalesChartData() {
    return this.httpClient.get(`dashboard/chart/sales`);
  }

  getCustomersChartData() {
    return this.httpClient.get(`dashboard/chart/customers`);
  }

  getProvidersChartData() {
    return this.httpClient.get(`dashboard/chart/providers`);
  }

  getOrdersChartData() {
    return this.httpClient.get(`dashboard/chart/orders`);
  }

  getRevenueChartData() {
    return this.httpClient.get(`dashboard/chart/revenue`);
  }
}
