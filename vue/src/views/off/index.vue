<template>
  <div class="app-container">
    <el-form ref="myForm" :model="search" label-width="80px">
      <div class="flex-container">
        <el-row>
          <el-col :span="1">
            <el-button type="primary" @click="addIn=true">新增</el-button>
          </el-col>
          <el-col :span="3">
            <el-form-item label="状态" >
              <el-select v-model="search.status" placeholder="状态" style="width:100%;">
                <el-option label="已审批" value="1"></el-option>
                <el-option label="未审批" value="0"></el-option>
                <el-option label="已报废" value="2"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="姓名">
              <el-select v-model="search.employeeName" placeholder="请选择">
                <el-option
                  v-for="option in selectedOption"
                  :key="option.name"
                  :label="option.name"
                  :value="option.name"
                />
              </el-select>
<!--            <el-input v-model="search.employeeName" placeholder="请输入姓名" maxlength="4" show-word-limit style="width: 90%;"></el-input>-->
            </el-form-item>
          </el-col >
          <el-col :span="4">
            <el-form-item label="开始日期">
              <el-date-picker v-model="search.startDate" type="date" placeholder="选择日期" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="结束日期">
              <el-date-picker v-model="search.endDate" type="date" placeholder="选择日期" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="类型" style="padding-right: 10px;">
              <el-select v-model="search.leaveType" placeholder="类型" style="width:100%;">
                <el-option label="病假" value="病假"></el-option>
                <el-option label="事假" value="事假"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
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
      stripe
      style="width: 100%"
      element-loading-text="Loading"
      border
      fit
      highlight-current-row>
      <el-table-column label="id" width="100" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.id }}</span>
        </template>
      </el-table-column>
      <el-table-column label="姓名" width="100" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.employeeName }}</span>
        </template>
      </el-table-column>
      <el-table-column label="类型" width="100" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.leaveType }}</span>
        </template>
      </el-table-column>
      <el-table-column label="原因" width="180" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.reason }}</span>
        </template>
      </el-table-column>
      <el-table-column class-name="status-col" label="状态" width="100" align="center">
        <template slot-scope="scope">
          <el-tag v-if="verifyStatus(scope.row.status)==='已审核'" type="success">{{ verifyStatus(scope.row.status) }}</el-tag>
          <el-tag v-else-if="verifyStatus(scope.row.status)==='未审核'" type="danger">{{ verifyStatus(scope.row.status) }}</el-tag>
          <el-tag v-else type="info">{{ verifyStatus(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="审批时间" width="120" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.approveDate }}</span>
        </template>
      </el-table-column>
      <el-table-column label="开始日期" width="120" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.startDate }}</span>
        </template>
      </el-table-column>
      <el-table-column label="结束日期" width="120" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.endDate }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="260" align="center">
        <template slot-scope="scope">
          <el-button circle type="primary" icon="el-icon-edit" round @click="EditRow(scope.row) "></el-button>
          <el-button circle type="warning" :plain="true" round @click="approve(scope.row,1)">审批</el-button>
          <el-button circle type="warning" :plain="true" round @click="approve(scope.row,2)">作废</el-button>
          <el-button circle type="danger" icon="el-icon-delete" :plain="true" round @click="DeleteRow(scope.row)"></el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      :page-sizes="[8, 10, 15, 20]"
      :total="total"
      layout="total, sizes, prev, pager, next, jumper"
      :page-size="pageSize"
      :current-page="currentPage"
      @size-change="handlePageSizeChange"
      @current-change="handleCurrentPageChange"
    />
    <el-dialog
      title="修改请假单"
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
        <el-form-item label="员工id">
          <el-input v-model="editdata.employeeId" :disabled="true" size="small" maxlength="10" show-word-limit />
        </el-form-item>
        <el-form-item label="员工姓名">
          <el-input v-model="editdata.employeeName" :disabled="true" maxlength="4" show-word-limit />
        </el-form-item>
        <el-form-item label="开始日期">
          <el-col :span="11">
            <el-date-picker v-model="editdata.startDate" type="date" placeholder="选择日期" style="width: 100%;" />
          </el-col>
        </el-form-item>
        <el-form-item label="结束日期">
          <el-col :span="11">
            <el-date-picker v-model="editdata.endDate" type="date" placeholder="选择日期" style="width: 100%;" />
          </el-col>
        </el-form-item>
        <el-form-item label="请假类型">
          <el-select v-model="editdata.leaveType" placeholder="类型" style="width:100%;">
            <el-option label="病假" value="病假"></el-option>
            <el-option label="事假" value="事假"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="原因">
          <el-input v-model="editdata.reason" maxlength="50" show-word-limit />
        </el-form-item>
        <el-form-item  v-if="verifyStatus(editdata.status)==='已审核'" label="审批状态">
          <el-input
            placeholder="已审核"
            :disabled="true">
          </el-input>
        </el-form-item>
        <el-form-item  v-else-if="verifyStatus(editdata.status)==='未审核'" label="审批状态">
          <el-input
            placeholder="未审核"
            :disabled="true">
          </el-input>
        </el-form-item>
        <el-form-item  v-else-if="verifyStatus(editdata.status)==='已作废'" label="审批状态">
          <el-input
            placeholder="已作废"
            :disabled="true">
          </el-input>
        </el-form-item>
        <el-form-item label="审批日期">
          <el-col :span="11">
            <el-date-picker v-model="editdata.approveDate" type="date" placeholder="选择日期" style="width: 100%;" />
          </el-col>
        </el-form-item>
      </el-form>

      <!-- 确定和取消按钮 -->
      <el-button type="primary" :plain="true" @click="onSubmit">确定</el-button>
      <el-button @click="onCancel">取消</el-button>
    </el-dialog>
    <el-dialog
      title="新增请假"
      :visible="addIn"
      @close="addIn = false,addData={}"
    >
      <el-form ref="addData" :model="addData" label-width="80px" size="mini" >
        <el-form-item label="员工id">
<!--          <el-select v-model="addData.employeeName" placeholder="请选择">-->
<!--            <el-option-->
<!--              v-for="option in selectedOption"-->
<!--              :key="option.name"-->
<!--              :label="option.name"-->
<!--              :value="option.name"-->
<!--            />-->
<!--          </el-select>-->
          <el-input v-model="addData.employeeId" size="small" maxlength="10" show-word-limit />
        </el-form-item>
        <el-form-item label="请假类型">
          <el-select v-model="addData.leaveType" placeholder="请假类型" style="width:100%;">
            <el-option label="病假" value="病假"></el-option>
            <el-option label="事假" value="事假"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="请假原因">
          <el-input v-model="addData.reason" size="small" maxlength="10" show-word-limit />
        </el-form-item>
        <el-form-item label="开始日期" >
          <el-col :span="11">
            <el-date-picker v-model="addData.startDate" type="date" placeholder="选择日期" style="width: 100%;" />
          </el-col>
        </el-form-item>
        <el-form-item label="结束日期">
          <el-col :span="11">
            <el-date-picker v-model="addData.endDate" type="date" placeholder="选择日期" style="width: 100%;" />
          </el-col>
        </el-form-item>
        <!-- 确定和取消按钮 -->
        <el-button type="primary" :plain="true" align="center" @click="submitAdd" >确定</el-button>
        <el-button @click="cancelAdd" align="center">取消</el-button>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'
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
        employeeName: '',
        employeeId: '',
        leaveType: '',
        status: '',
        startDate: '',
        endDate: ''
      },
      addData: {
        employeeId: '',
        leaveType: '',
        startDate: '',
        reason: '',
        endDate: ''
      },
      editdata: {
        employeeName: '',
        employeeId: '',
        leaveType: '',
        status: '',
        startDate: '',
        endDate: '',
        id: '',
        reason: '',
        approveDate: ''
      },
      selectedOption: [],
      list: {
        employeeName: '',
        employeeId: '',
        leaveType: '',
        status: '',
        startDate: '',
        endDate: '',
        id: '',
        reason: '',
        approveDate: ''
      }
    }
  },
  created() {
    this.fetchData(this.pageSize, this.currentPage)
  },
  methods: {
    fetchData(size, page) {
      this.listLoading = true
      axios.post('http://localhost:10010/off/all', { size, page })
        .then(response => {
          this.list = response.data.data.records
          this.total = response.data.data.total
          this.listLoading = false
        })
      axios.get('http://localhost:10010/user/list').then(
        response => {
          this.selectedOption = response.data
        }
      )
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
      console.log(formData)
      axios.post('http://localhost:10010/off/listwith', formData)
        .then(response => {
          this.list = response.data.data.records
          this.total = response.data.data.total
          this.listLoading = false
        })
    },
    verifyStatus(status) {
      if (status === 0) {
        return '未审核'
      } else if (status === 1) {
        return '已审核'
      } else if (status === 2) {
        return '已作废'
      }
    },
    deleteall() {
      this.search = {}
      this.currentPage = 1
      this.fetchData(this.pageSize, this.currentPage)
    },
    EditRow(row) {
      this.editdata = { ...row }
      this.editFormVisible = true
    },
    DeleteRow(row) {
      axios.delete(`http://localhost:10010/off/delete/${row.id}`)
        .then(response => {
          this.fetchData(this.pageSize, this.currentPage)
          this.$message({
            message: '删除成功',
            type: 'success'
          })
        })
    },
    approve(row, flag) {
      if (row.status === 1 || row.status === 2) {
        this.$message.error('该单据已审批或报废，不可再次操作')
      } else {
        axios.put(`http://localhost:10010/off/updateStatus/${flag}`, row)
          .then(response => {
            this.searchWithForm()
            if (flag === 1) {
              this.$message({
                message: '审批成功',
                type: 'success'
              })
            } else if (flag === 2) {
              this.$message({
                message: '报废成功',
                type: 'success'
              })
            }
          })
      }
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
    onSubmit() {
      axios.put('http://localhost:10010/off/update', this.editdata)
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
    cancelAdd() {
      this.addIn = false
      this.addData = {}
    },
    submitAdd() {
      axios.post('http://localhost:10010/off/add', this.addData)
        .then(response => {
          this.fetchData(this.pageSize, this.currentPage)
          this.addIn = false
          this.addData = {}
          this.$message({
            message: '新增成功',
            type: 'success'
          })
        })
    }
  }
}
</script>

