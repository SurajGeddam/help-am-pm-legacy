
<html>
<head>
<style>

@page {
    @top-right {
        content: "Page " counter(page) " of " counter(pages);
        font-family: sans-serif;
        padding-right: 15px;
    }
}

#invoice{
    padding: 0px;
}

.invoice {
    position: relative;
    padding: 15px
}

.invoice header {
    padding: 10px 0;
    margin-bottom: 20px;
    border-bottom: 1px solid #3989c6
}

.invoice .company-details {
    text-align: right
}

.invoice .company-details .name {
    margin-top: 0;
    margin-bottom: 0
}

.invoice .contacts {
    margin-bottom: 20px
}

.invoice .invoice-to {
    text-align: left
}

.invoice .invoice-to .to {
    margin-top: 0;
    margin-bottom: 0
}

.invoice .invoice-details {
    text-align: right
}

.invoice .invoice-details .invoice-id {
    margin-top: 0;
    color: #3989c6
}

.invoice main {
    padding-bottom: 50px
}

.invoice main .thanks {
    margin-top: -100px;
    font-size: 2em;
    margin-bottom: 50px
}

.invoice main .notices {
    padding-left: 6px;
    border-left: 6px solid #3989c6
}

.invoice main .notices .notice {
    font-size: 1.2em
}

.invoice table {
    width: 100%;
    border-collapse: collapse;
    border-spacing: 0;
    margin-bottom: 20px
}

.invoice table td,.invoice table th {
    padding: 10px;
    background: #eee;
    border-bottom: 1px solid #fff
}

.invoice table th {
    white-space: nowrap;
    font-weight: 400;
    font-size: 16px
}

.invoice table td h3 {
    margin: 0;
    font-weight: 400;
    color: #e3d044;
    font-size: 1.2em
}

.invoice table .qty,.invoice table .total,.invoice table .unit {
    text-align: right;
    font-size: 1.2em
}

.invoice table .no {
    color: #fff;
    font-size: 1.6em;
    background: #d6c540
}

.invoice table .unit {
    background: #ddd
}

.invoice table .total {
    background: #d6c540;
    color: #fff
}

.invoice table tbody tr:last-child td {
    border: none
}

.invoice table tfoot td {
    background: 0 0;
    border-bottom: none;
    white-space: nowrap;
    text-align: right;
    padding: 10px 20px;
    font-size: 1.2em;
    border-top: 1px solid #aaa
}

.invoice table tfoot tr:first-child td {
    border-top: none
}

.invoice table tfoot tr:last-child td {
    color: #3989c6;
    font-size: 1.4em;
    border-top: 1px solid #3989c6
}

.invoice table tfoot tr td:first-child {
    border: none
}

.invoice footer {
    width: 100%;
    text-align: center;
    color: #777;
    border-top: 1px solid #aaa;
    padding: 8px 0
}
.invoice {
    font-size: 12px;
    line-height: 1.2;
    font-family: sans-serif;
}
a.logo {
    display: inline-block;
    text-decoration: none;
}
tr, tfoot {
    page-break-inside: avoid;
}
div.logo-container {
    float: left;
}
</style>
</head>
<body>

<!--Author      : @arboshiki-->
<div id="invoice">
    <div class="invoice">
        <div>
            <header>
                <div class="row">
                    <div class="logo-container">
                       <a class="logo" th:if="${not #strings.isEmpty(helpCompanyDetails.logoFile)}" th:href="${helpCompanyDetails.website}">
                           <img th:src="${helpCompanyDetails.logoFile}" alt="Business Logo" />
                       </a>
                    </div>
                    <div class="col company-details">
                        <h2 class="name">
                            <a th:unless="${#strings.isEmpty(helpCompanyDetails.website)}" th:href="${helpCompanyDetails.website}" th:text="${helpCompanyDetails.name}"></a>
                            <span th:if="${#strings.isEmpty(helpCompanyDetails.website)}" th:text="${helpCompanyDetails.name}"></span>
                        </h2>
                        <div th:if="${helpAddress neq null}">
                          <th:block th:with="addr = ${helpAddress}">
                            <th:block th:text="${#strings.arrayJoin({addr.line1, addr.line2, addr.county,addr.country, addr.zipcode}.{? #this neq null}, ', ')}"></th:block>
                          </th:block>
                        </div>
                        <div class="email" th:if="${not #strings.isEmpty(helpCompanyDetails.email)}"><a th:href="|mailto:${helpCompanyDetails.email}|" th:text="${helpCompanyDetails.email}"></a></div>
                    </div>
                </div>
                <div style="clear: both;"></div>
            </header>
            <main>
                <div class="row contacts">
                    <div class="col invoice-to">
                        <div class="text-gray-light">INVOICE TO:</div>
                        <h2 class="to" th:text="${invoice.customer.name}">John Doe</h2>
                        <div class="address" th:if="${invoice.customer.address neq null}">
                            <th:block th:with="addr = ${invoice.customer.address}">
                                <th:block th:text="${invoice.customer.address}"></th:block>
                            </th:block>
                        </div>
                        <div class="email" th:if="${not #strings.isEmpty(invoice.customer.email)}"><a th:href="|mailto:${invoice.customer.email}|" th:text="${invoice.customer.email}"></a></div>
                    </div>
                    <div class="col invoice-details">
                        <h4 class="invoice-id">Invoice Id- <th:block th:text="${invoice.uniqueId}"></th:block></h4>
                        <div class="payment">Payment Via: Debit</div>
                        <div class="date">Date of Invoice: <th:block th:text="${#temporals.format(invoice.createdAt, 'yyyy-MMM-dd')}"></th:block></div>
                    </div>
                </div>
                <table border="0" cellspacing="0" cellpadding="0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th class="text-left" colspan="2">DESCRIPTION</th>
                            <th class="text-right">UNIT PRICE</th>
                            <th class="text-right">TOTAL</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr th:each="itm : ${invoice.items}">
                            <td class="no" colspan="2" th:text="${itmStat.index + 1}"></td>
                            <td class="text-left" th:text="${itm.description}"></td>
                            <td class="unit" th:text="${invoice.currency +''+
                            #numbers.formatDecimal(itm.price, 0, 'COMMA', 2, 'POINT')}">
                            </td>
                            <td class="total" th:text="${invoice.currency +''+
                            #numbers.formatDecimal(itm.price, 0, 'COMMA', 2, 'POINT')}"></td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="2"></td>
                            <td colspan="2">SUBTOTAL</td>
                            <td th:text="${invoice.currency+'' +
                            #numbers.formatDecimal(invoice.subTotal, 0, 'COMMA', 2, 'POINT')}"></td>
                        </tr>
                        <tr>
                            <td colspan="2"></td>
                            <td colspan="2"><th:block th:text="${invoice.tax.name}"></th:block></td>
                            <td th:text="${invoice.currency+'' +
                            #numbers.formatDecimal(invoice.tax.amount, 0, 'COMMA', 2, 'POINT')}"></td>
                        </tr>
                        <tr>
                            <td colspan="2"></td>
                            <td colspan="2">GRAND TOTAL</td>
                            <td th:text="${invoice.currency+'' +
                            #numbers.formatDecimal(invoice.totalPrice, 0, 'COMMA', 2, 'POINT')}"></td>
                        </tr>
                    </tfoot>
                </table>

            </main>
            <footer>
                Invoice was created on a computer and is valid without the signature and seal.
            </footer>
        </div>
    </div>
</div>
</body>
</html>
