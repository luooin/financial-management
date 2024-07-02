<template>
  <div class="app-container">
    <el-form ref="myForm" :model="search" label-width="80px">
      <div class="flex-container">
        <el-row>
          <el-col :span="1">
            <el-button type="primary" @click="addIn=true">生成</el-button>
          </el-col>
          <el-col :span="4">
            <el-form-item label="分类">
              <el-select v-model="search.transactionType" placeholder="请选择">
                <el-option value="支出"></el-option>
                <el-option value="收入"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="类别">
              <el-select v-model="search.category" placeholder="请选择">
                <el-option
                  v-for="option in selectedOption"
                  :key="option"
                  :label="option"
                  :value="option"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="时间">
              <el-date-picker v-model="search.date" type="date" placeholder="选择日期" style="width: 100%;"/>
            </el-form-item>
          </el-col>
          <el-col :span="1"></el-col>
          <el-col :span="2">
            <el-button type="primary" icon="el-icon-search" @click="searchWithForm">搜索</el-button>
          </el-col>
          <el-col :span="2">
            <el-button type="info" icon="el-icon-delete-solid" @click="deleteall">清空</el-button>
          </el-col>

        </el-row>
      </div>
    </el-form>

    <el-table
      v-loading="listLoading"
      :data="list"
      element-loading-text="Loading"
      border
      style="width: 100%"
      fit>
      <el-table-column label="时间" width="150" align="center">
        <template slot-scope="scope">
          {{ formatDate(scope.row.date) }}
        </template>
      </el-table-column>
      <el-table-column label="类别" width="140" align="center">
        <template slot-scope="scope">
          {{ scope.row.category }}
        </template>
      </el-table-column>
      <el-table-column label="分类" width="150" align="center">
        <template slot-scope="scope">
          {{ scope.row.transactionType }}
        </template>
      </el-table-column>
      <el-table-column label="支付方式" width="130" align="center">
        <template slot-scope="scope">
          {{ scope.row.paymentMethod }}
        </template>
      </el-table-column>
      <el-table-column label="部门" width="150" align="center">
        <template slot-scope="scope">
          {{ verifyDepa(scope.row.departmentId )}}
        </template>
      </el-table-column>
      <el-table-column label="描述" width="250" align="center">
        <template slot-scope="scope">
          {{ scope.row.description }}
        </template>
      </el-table-column>
      <el-table-column label="金额" width="130" align="center">
        <template slot-scope="scope">
          {{ scope.row.amount }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="120" align="center">
        <template slot-scope="scope">
          <el-button circle type="primary" icon="el-icon-edit" round @click="EditRow(scope.row) "></el-button>
          <el-button
            circle type="danger" icon="el-icon-delete" :plain="true" round
            @click="DeleteRow(scope.row)"></el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      :page-sizes="[8, 16, 24]"
      :total="total"
      layout="total, sizes, prev, pager, next, jumper"
      :page-size="pageSize"
      :current-page="currentPage"
      @size-change="handlePageSizeChange"
      @current-change="handleCurrentPageChange"
    />

    <el-dialog
      title="生成收支单"
      :visible="addIn"
      @close="addIn = false"
    >
      <el-form ref="addData" :model="addData" label-width="80px" size="mini">
        <el-form-item label="时间">
          <el-date-picker
            v-model="addData.date"
            type="date"
            placeholder="选择日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="addData.description" maxlength="50" show-word-limit/>
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="addData.transactionType" placeholder="请选择">
            <el-option value="支出"></el-option>
            <el-option value="收入"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="类别">
          <el-select v-model="addData.category" placeholder="请选择">
            <el-option
              v-for="option in selectedOption"
              :key="option"
              :label="option"
              :value="option"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="所属部门">
          <el-select v-model="addData.departmentId" placeholder="请选择">
            <el-option
              v-for="option in departmentList"
              :key="option.id"
              :label="option.name"
              :value="option.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="金额">
          <el-input v-model="addData.amount" maxlength="50" show-word-limit/>
        </el-form-item>
        <el-form-item label="支付方式">
          <el-select v-model="addData.paymentMethod" placeholder="请选择">
            <el-option
              v-for="option in selectedMethod"
              :key="option"
              :label="option"
              :value="option"
            ></el-option>
          </el-select>
        </el-form-item>
        <!-- 确定和取消按钮 -->
        <el-button type="primary" :plain="true" align="center" @click="submitAdd">确定</el-button>
        <el-button @click="cancelAdd" align="center">取消</el-button>
      </el-form>
    </el-dialog>

    <el-dialog
      title="修改工资单"
      :visible="editFormVisible"
      @close="editFormVisible = false"
    >
      <el-form ref="editdata" :model="editdata" label-width="80px" size="mini">
        <!-- 表单项 -->
        <el-form-item label="主键">
          <el-input
            v-model="editdata.id"
            placeholder="主键id"
            :disabled="true"
            size="mini"
            maxlength="5"
          />
        </el-form-item>
        <el-form-item label="时间">
          <el-date-picker
            v-model="editdata.date"
            type="date"
            placeholder="选择日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="editdata.description" maxlength="50" show-word-limit/>
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="editdata.transactionType" placeholder="请选择">
            <el-option value="支出"></el-option>
            <el-option value="收入"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="类别">
          <el-select v-model="editdata.category" placeholder="请选择">
            <el-option
              v-for="option in selectedOption"
              :key="option"
              :label="option"
              :value="option"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="所属部门">
          <el-select v-model="editdata.departmentId" placeholder="请选择">
            <el-option
              v-for="option in departmentList"
              :key="option.id"
              :label="option.name"
              :value="option.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="金额">
          <el-input v-model="editdata.amount" maxlength="50" show-word-limit/>
        </el-form-item>
        <el-form-item label="支付方式">
          <el-select v-model="editdata.paymentMethod" placeholder="请选择">
            <el-option
              v-for="option in selectedMethod"
              :key="option"
              :label="option"
              :value="option"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <!-- 确定和取消按钮 -->
      <el-button type="primary" :plain="true" @click="onSubmit">确定</el-button>
      <el-button @click="onCancel">取消</el-button>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
import moment from 'moment'

export default {
  data() {
    return {
      addIn: false,
      listLoading: true,
      currentPage: 1, // 当前页码
      pageSize: 8, // 每页显示的数据条数
      total: 0, // 表格中数据的总条数
      editFormVisible: false, // 控制弹出框的显示与隐藏
      search: {
        date: '',
        transactionType: '',
        category: '',
        paymentMethod: '',
        departmentId: ''
      },
      selectedOption: [],
      selectedMethod: [],
      departmentList: [],
      list: {
        date: '',
        transactionType: '',
        amount: '',
        description: '',
        category: '',
        paymentMethod: '',
        departmentId: '',
        employeeId: ''
      },
      editdata: {
        id: '',
        date: '',
        transactionType: '',
        amount: '',
        description: '',
        category: '',
        paymentMethod: '',
        departmentId: '',
        employeeId: ''
      },
      addData: {
        date: '',
        transactionType: '',
        amount: '',
        description: '',
        category: '',
        paymentMethod: '',
        departmentId: '',
        employeeId: ''
      }
    }
  },
  created() {
    this.fetchData(this.pageSize, this.currentPage)
  },
  methods: {
    verifyDepa(id) {
      for (var i = 0 ; i < this.departmentList.length ; i++ ) {
        if(this.departmentList[i].id == id){
          return this.departmentList[i].name
        }
      }
    },
    onSubmit() {
      axios.put('http://localhost:10010/order/update', this.editdata)
        .then(response => {
          this.$message({
            message: '修改成功',
            type: 'success'
          })
          this.fetchData(this.pageSize, this.currentPage)
          this.editFormVisible = false
        })
    },
    onCancel() {
      this.editFormVisible = false
    },
    EditRow(row) {
      // this.editFormData = { ...row }
      this.editdata = {...row}
      this.editFormVisible = true
    },
    DeleteRow(row) {
      axios.delete(`http://localhost:10010/order/delete/${row.id}`)
        .then(response => {
          this.fetchData(this.pageSize, this.currentPage)
          this.$message({
            message: '删除成功',
            type: 'success'
          })
        })
    },
    departmentTransform(id) {
      axios.get(`http://localhost:10010/order/getDepartmentName/${id}`)
        .then(response => {
          return response.data
        })
    },
    formatDate(date) {
      return moment(date).format('YYYY-MM-DD')
    },
    handlePageSizeChange(newSize) {
      this.pageSize = newSize
      this.currentPage = 1 // 切换每页显示条数时，重置当前页码为第一页
      this.searchWithForm()
    },
    handleCurrentPageChange(newPage) {
      this.currentPage = newPage
      this.searchWithForm()
    },
    fetchData(size, page) {
      axios.get('http://localhost:10010/order/getCategory')
        .then(res => {
          this.selectedOption = res.data.data
        })
      axios.get('http://localhost:10010/order/getPayment')
        .then(res => {
          this.selectedMethod = res.data.data
        })
      axios.get('http://localhost:10010/order/getDepartment')
        .then(res => {
          this.departmentList = res.data
        })
      this.listLoading = true
      axios.post('http://localhost:10010/order/list', {size, page})
        .then(response => {
          this.list = response.data.data.records
          this.total = response.data.data.total
          this.listLoading = false
        })
    },
    deleteall() {
      this.search = {}
      this.currentPage = 1
      this.fetchData(this.pageSize, this.currentPage)
    },
    searchWithForm() {
      const form = this.$refs.myForm
      let formData = form.model
      // 将formData重新赋值为响应式的对象
      formData = Object.assign({}, formData)
      formData.size = this.pageSize
      formData.page = this.currentPage
      this.$set(formData, 'size', this.pageSize)
      this.$set(formData, 'page', this.currentPage)
      axios.post('http://localhost:10010/order/listwith', formData)
        .then(response => {
          this.list = response.data.data.records
          this.total = response.data.data.total
          this.listLoading = false
        })
    },
    cancelAdd() {
      this.addIn = false
      this.addData = {}
    },
    submitAdd() {
      axios.post('http://localhost:10010/order/add', this.addData)
        .then(response => {
          if (response.data.code === 1) {
            this.fetchData(this.pageSize, this.currentPage)
            this.addIn = false
            this.$message({
              message: '生成成功',
              type: 'success'
            })
            this.addData = {}
          }
        })
    }
  }
}
</script>

