<template>
  <div class="app-container">
    <el-container>
      <el-header style="display: none">
      </el-header>
      <el-main>
        <el-row :gutter="20" class="mgb20">
          <el-col :span="8">
            <el-card shadow="hover" :body-style="{padding: '0px'}">
              <div class="grid-content grid-con-1">
                <div class="grid-cont-right">
                  <div class="grid-num">{{profit}}</div>
                  <div>当前利润</div>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="hover" :body-style="{padding: '0px'}">
              <div class="grid-content grid-con-2">
                <div class="grid-cont-right">
                  <div class="grid-num">{{payout}}</div>
                  <div>总支出</div>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="hover" :body-style="{padding: '0px'}">
              <div class="grid-content grid-con-3">
                <div class="grid-cont-right">
                  <div class="grid-num">{{earn}}</div>
                  <div>总收入</div>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
        <el-row :gutter="20" >
          <el-col :span="8">
            <div id="menu1" style="width: 400px;height: 300px" align="center"></div>
          </el-col>
          <el-col :span="8">
            <div id="menu2" style="width: 400px;height: 300px" align="center"></div>
          </el-col>
          <el-col :span="8">
            <div id="menu3" style="width: 400px;height: 300px" align="center"></div>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="7">
            <div id="category" style="width: 400px;height: 450px" align="center"></div>
          </el-col>
          <el-col :span="5" style="width: 20%;" align="center">
            <el-table
              stripe
              :data="srData"
              style="width: 100%; height: 380px">
              <el-table-column
                prop="description"
                label="详情">
              </el-table-column>
              <el-table-column
                prop="amount"
                label="金额">
              </el-table-column>
            </el-table>
            <el-pagination
              :page-sizes="[8, 16, 24]"
              layout="prev, pager, next"
              :page-size="pageSizeb"
              :current-page="currentPageb"
              @size-change="handlePageSizeChangeb"
              @current-change="handleCurrentPageChangeb"
            />
          </el-col>
          <el-col :span="5" style="width: 20%" align="center">
            <el-table
              stripe
              :data="zcData"
              style="width: 100%; height: 380px">
              <el-table-column
                prop="description"
                label="详情">
              </el-table-column>
              <el-table-column
                prop="amount"
                label="金额">
              </el-table-column>
            </el-table>
            <el-pagination
              :page-sizes="[8, 16, 24]"
              layout="prev, pager, next"
              :page-size="pageSize"
              :current-page="currentPage"
              @size-change="handlePageSizeChange"
              @current-change="handleCurrentPageChange"
            />
          </el-col>
          <el-col :span="7">
            <div id="shouru" style="width: 400px;height: 450px" align="center"></div>
          </el-col>
        </el-row>
        <el-row :gutter="20">
        </el-row>
      </el-main>
    </el-container>
  </div>
</template>

<script >
import axios from 'axios'
import * as echarts from 'echarts'
export default {
  data() {
    return {
      earn: '',
      payout: '',
      profit: '',
      a: {},
      userList: [],
      selectedOption: [],
      id: '',
      xzhou: [],
      yzhou: [],
      map: {},
      category: [],
      shouru: [],
      zcData: [],
      srData: [],
      currentPage: 1, // 当前页码
      pageSize: 8, // 每页显示的数据条数
      currentPageb: 1, // 当前页码
      pageSizeb: 8, // 每页显示的数据条数
      departmentsr: [],
      departmentzc: [],
      menu1x: [],
      menu1y: [],
      menu2x: [],
      menu2y: [],
      menu3x: [],
      menu3y: []
    }
  },
  created() {
    this.getuserList()
    this.onloadData()
    this.drawEcharts()
  },
  mounted() {
    this.initEcharts()
    this.inittotal()
    this.drawEcharts()
  },
  methods: {
    handlePageSizeChange(newSize) {
      this.pageSize = newSize
      this.currentPage = 1 // 切换每页显示条数时，重置当前页码为第一页
      this.onloadData()
    },
    handleCurrentPageChange(newPage) {
      this.currentPage = newPage
      this.onloadData()
    },
    handlePageSizeChangeb(newSize) {
      this.pageSizeb = newSize
      this.currentPageb = 1 // 切换每页显示条数时，重置当前页码为第一页
      this.onloadData()
    },
    handleCurrentPageChangeb(newPage) {
      this.currentPageb = newPage
      this.onloadData()
    },
    onloadData() {
      axios.get('http://localhost:10010/order/getData').then(response => {
        this.profit = response.data.data.profit
        this.payout = response.data.data.payout
        this.earn = response.data.data.earn
      })
      axios.post('http://localhost:10010/order/getZc', { 'page': this.currentPageb, 'size': this.pageSizeb })
        .then(response => {
          this.zcData = response.data.data
        })
      axios.post('http://localhost:10010/order/getSr', { 'page': this.currentPageb, 'size': this.pageSizeb })
        .then(response => {
          this.srData = response.data.data
        })
    },
    deleteall() {
      this.a = {}
    },
    submitMulti(a) {
      axios.post('http://localhost:10010/salary/compare', a)
        .then(response => {
          this.map = response.data.data
        })
    },
    inittotal() {
      var chartDom = document.getElementById('main')
      var myChart = echarts.init(chartDom)
      var option
      option = {
        legend: {},
        tooltip: {},
        dataset: {
          source: this.map
        },
        xAxis: { type: 'category' },
        yAxis: {},
        series: [{ type: 'bar' }, { type: 'bar' }, { type: 'bar' }]
      }
      option && myChart.setOption(option)
    },
    drawEcharts() {
      axios.post('http://localhost:10010/order/category')
        .then(response => {
          response.data.data.forEach(item => {
            var da = {
              value: item.value,
              name: item.name
            }
            this.category.push(da)
          })
          console.log(this.category)
          var chartDoma = document.getElementById('category')
          var categoryDom = echarts.init(chartDoma)
          var option = {
            title: {
              text: '支出项占比',
              subtext: '分类',
              left: 'center'
            },
            tooltip: {
              trigger: 'item'
            },
            series: [
              {
                name: this.category.name,
                type: 'pie',
                radius: '50%',
                data: this.category,
                emphasis: {
                  itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                  }
                }
              }
            ]
          }
          option && categoryDom.setOption(option)
        })
      axios.post('http://localhost:10010/order/categorysr')
        .then(response => {
          response.data.data.forEach(item => {
            var da = {
              value: item.value,
              name: item.name
            }
            this.shouru.push(da)
          })
          var chartDomb = document.getElementById('shouru')
          var categorysrDom = echarts.init(chartDomb)
          var option = {
            title: {
              text: '收入项占比',
              subtext: '分类',
              left: 'center'
            },
            tooltip: {
              trigger: 'item'
            },
            series: [
              {
                name: this.shouru.name,
                type: 'pie',
                radius: '50%',
                data: this.shouru,
                emphasis: {
                  itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                  }
                }
              }
            ]
          }
          option && categorysrDom.setOption(option)
        })
      axios.get('http://localhost:10010/order/getDepartmentData').then(response => {
        this.departmentzc = response.data.data
        var chartDomd = document.getElementById('departmentSr')
        var categorysrDomd = echarts.init(chartDomd)
        var optiond = {
          series: [
            {
              name: 'Access From',
              type: 'pie',
              radius: '50%',
              startAngle: -180,
              endAngle: 0,
              data: this.departmentsr
            }
          ]
        }
        optiond && categorysrDomd.setOption(optiond)
      })
      axios.get('http://localhost:10010/order/getDepartmentDatasr').then(response => {
        this.departmentsr = response.data.data
        var chartDomc = document.getElementById('departmentZc')
        var categorysrDomc = echarts.init(chartDomc)
        var optionc = {
          series: [
            {
              name: 'Access From',
              type: 'pie',
              radius: '50%',
              startAngle: -180,
              endAngle: 0,
              data: this.departmentzc
            }
          ]
        }
        optionc && categorysrDomc.setOption(optionc)
      })
      axios.post('http://localhost:10010/order/menu1')
        .then(response => {
          debugger
          // this.menu1x = response.data.data[0]
          // this.menu1y = response.data.data[1]
          var dom1 = document.getElementById('menu1')
          var myChart = echarts.init(dom1)
          var option = {
            tooltip: {
              trigger: 'axis'
            },
            xAxis: {
              type: 'category',
              data: response.data.data[0]
            },
            yAxis: {
              type: 'value'
            },
            series: [
              {
                data: response.data.data[1],
                type: 'line',
                smooth: true
              }
            ]
          }
          option && myChart.setOption(option)
        })
      axios.post('http://localhost:10010/order/menu2')
        .then(response => {
          this.menu2x = response.data.data[0]
          this.menu2y = response.data.data[1]
          var dom2 = document.getElementById('menu2')
          var myChart = echarts.init(dom2)
          var option = {
            tooltip: {
              trigger: 'axis'
            },
            xAxis: {
              type: 'category',
              data: this.menu2x
            },
            yAxis: {
              type: 'value'
            },
            series: [
              {
                data: this.menu2y,
                type: 'line',
                smooth: true
              }
            ]
          }
          option && myChart.setOption(option)
        })
      axios.post('http://localhost:10010/order/menu3')
        .then(response => {
          this.menu3x = response.data.data[0]
          this.menu3y = response.data.data[1]
          var dom3 = document.getElementById('menu3')
          var myChart = echarts.init(dom3)
          var option = {
            tooltip: {
              trigger: 'axis'
            },
            xAxis: {
              type: 'category',
              data: this.menu3x
            },
            yAxis: {
              type: 'value'
            },
            series: [
              {
                data: this.menu3y,
                type: 'line',
                smooth: true
              }
            ]
          }
          option && myChart.setOption(option)
        })
    },
    initEcharts() {
      var chartDom = document.getElementById('bie')
      var myChart = echarts.init(chartDom)
      var option
      option = {
        xAxis: {
          type: 'category',
          data: this.xzhou
        },
        yAxis: {
          type: 'value'
        },
        series: [
          {
            data: this.yzhou,
            type: 'line',
            smooth: true
          }
        ]
      }
      option && myChart.setOption(option)
    },
    transferData(list) {
      list.forEach(item => {
        this.xzhou.push(item.salaryMonth)
        this.yzhou.push(item.getSalary)
      })
    },
    onSubmit(id) {
      axios.get(`http://localhost:10010/salary/${id}`)
        .then(response => {
          this.xzhou = []
          this.yzhou = []
          this.userList = response.data
          this.transferData(this.userList)
          this.initEcharts()
        })
    },
    getuserList() {
      axios.get('http://localhost:10010/user/list').then(
        response => {
          this.selectedOption = response.data
        }
      )
    }
  }
}
</script>
<style lang="scss" scoped>
$bg:#2d3a4b;
$dark_gray:#889aa4;
$light_gray:#eee;
.app-container {
  &-container {
    margin: 30px;
  }
  &-text {
    font-size: 30px;
    line-height: 46px;
  }
}
</style>

<style>
.el-row {
  margin-bottom: 20px;
  &:last-child {
    margin-bottom: 0;
  }
}
.el-col {
  border-radius: 4px;
}
.grid-content {
  border-radius: 4px;
  min-height: 36px;
}
.row-bg {
  padding: 10px 0;
  background-color: #f9fafc;
}
.app-container {
  background-color: #f5f5f5;
}
.grid-content {
  display: flex;
  align-items: center;
  height: 100px;
}

.grid-cont-right {
  flex: 1;
  text-align: center;
  font-size: 14px;
  color: black;
}

.grid-num {
  font-color: black;
  font-size: 30px;
  font-weight: bold;
}
</style>
