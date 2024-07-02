<template>
  <div class="app-container">
    <el-form ref="myForm" :model="search" label-width="80px">
      <div class="flex-container">
        <el-row>
          <el-col :span="2">
            <el-button type="primary" @click="addInvoice">新增</el-button>
          </el-col>
          <el-col :span="3">
            <el-form-item label="审批状态">
              <el-select v-model="search.approveStatus" placeholder="审批状态" style="width:100%;">
                <el-option label="已审批" value="1" />
                <el-option label="未审批" value="0" />
                <el-option label="已报废" value="2" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="5">
            <el-form-item label="发票号">
              <el-select v-model="search.number" placeholder="请选择">
                <el-option
                  v-for="option in selectedNumber"
                  :key="option"
                  :label="option"
                  :value="option"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="开票日期">
              <el-date-picker v-model="search.issueDate" type="date" placeholder="选择日期" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="5">
            <el-form-item label="用户">
              <el-select v-model="search.userId" placeholder="请选择">
                <el-option
                  v-for="option in selectedUser"
                  :key="option.id"
                  :label="option.name"
                  :value="option.id"
                />
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
      element-loading-text="Loading"
      border
      fit
      highlight-current-row
    >

      <el-table-column label="发票号码" width="120" align="center">
        <template slot-scope="scope">
          {{ scope.row.number }}
        </template>
      </el-table-column>

<!--      <el-table-column label="顾客id" width="80" align="center">-->
<!--        <template slot-scope="scope">-->
<!--          <span>{{ scope.row.customerId }}</span>-->
<!--        </template>-->
<!--      </el-table-column>-->

      <el-table-column label="开票日期" width="130" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.issueDate }}</span>
        </template>
      </el-table-column>

      <el-table-column label="到期日期" width="130" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.dueDate }}</span>
        </template>
      </el-table-column>

      <el-table-column label="总金额" width="120" align="center">
        <template slot-scope="scope">
          {{ scope.row.totalAmount }}
        </template>
      </el-table-column>

      <el-table-column label="用户" width="90" align="center">
        <template slot-scope="scope">
          {{ verifyuser(scope.row.userId )}}
        </template>
      </el-table-column>

      <el-table-column label="审批时间" width="130" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.approveDate }}</span>
        </template>
      </el-table-column>
      <el-table-column label="审批人" width="110" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.employee.name }}</span>
        </template>
      </el-table-column>

      <el-table-column class-name="status-col" label="状态" width="130" align="center">
        <template slot-scope="scope">
          <el-tag v-if="verifyStatus(scope.row.approveStatus)==='已审批'" type="success">{{ verifyStatus(scope.row.approveStatus) }}</el-tag>
          <el-tag v-else-if="verifyStatus(scope.row.approveStatus)==='已作废'" type="danger">{{ verifyStatus(scope.row.approveStatus) }}</el-tag>
          <el-tag v-else type="info">{{ verifyStatus(scope.row.approveStatus) }}</el-tag>
        </template>
      </el-table-column>

      <el-table-column label="操作" width="240" align="center">
        <template slot-scope="scope">
          <el-button circle type="primary" icon="el-icon-edit" round @click="EditRow(scope.row) " />
          <el-button circle type="warning" :plain="true" round @click="approve(scope.row,1)">审批</el-button>
          <el-button circle type="warning" :plain="true" round @click="approve(scope.row,2)">作废</el-button>
          <el-button circle type="danger" icon="el-icon-delete" :plain="true" round @click="DeleteRow(scope.row)" />
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
      title="修改审批单"
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
        <el-form-item label="发票号">
          <el-input v-model="editdata.number" size="small" maxlength="10" show-word-limit />
        </el-form-item>

<!--        <el-form-item label="顾客id">-->
<!--          <el-input v-model="editdata.customerId" maxlength="10" show-word-limit />-->
<!--        </el-form-item>-->
        <el-form-item label="总金额">
          <el-input v-model="editdata.totalAmount" maxlength="10" show-word-limit />
        </el-form-item>
        <el-form-item label="开票日期">
          <el-col :span="11">
            <el-date-picker v-model="editdata.issueDate" type="date" placeholder="选择日期" style="width: 100%;" />
          </el-col>
        </el-form-item>
        <el-form-item label="发票到期日期">
          <el-col :span="11">
            <el-date-picker v-model="editdata.dueDate" type="date" placeholder="选择日期" style="width: 100%;" />
          </el-col>
        </el-form-item>
        <el-form-item label="用户">
          <el-input v-model="editdata.userId" maxlength="3" show-word-limit />
        </el-form-item>
        <el-form-item v-if="verifyStatus(editdata.approveStatus)==='已审核'" label="审批状态">
          <el-input
            placeholder="已审核"
            :disabled="true"
          />
        </el-form-item>
        <el-form-item v-else-if="verifyStatus(editdata.approveStatus)==='未审核'" label="审批状态">
          <el-input
            placeholder="未审核"
            :disabled="true"
          />
        </el-form-item>
        <el-form-item v-else-if="verifyStatus(editdata.approveStatus)==='已作废'" label="审批状态">
          <el-input
            placeholder="已作废"
            :disabled="true"
          />
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
      title="新增发票"
      :visible="addIn"
      @close="addIn = false"
    >
      <el-form ref="addData" :model="addData" label-width="80px" size="mini">
        <el-form-item label="发票号">
          <el-input v-model="addData.number" size="small" maxlength="10" show-word-limit />
        </el-form-item>
<!--        <el-form-item label="顾客id">-->
<!--          <el-input v-model="addData.customerId" maxlength="10" show-word-limit />-->
<!--        </el-form-item>-->
        <el-form-item label="总金额">
          <el-input v-model="addData.totalAmount" maxlength="10" show-word-limit />
        </el-form-item>
        <el-form-item label="开票日期">
          <el-col :span="11">
            <el-date-picker v-model="addData.issueDate" type="date" placeholder="选择日期" style="width: 100%;" />
          </el-col>
        </el-form-item>
        <el-form-item label="发票到期日期">
          <el-col :span="11">
            <el-date-picker v-model="addData.dueDate" type="date" placeholder="选择日期" style="width: 100%;" />
          </el-col>
        </el-form-item>
        <el-form-item label="用户">
          <el-select v-model="addData.userId" placeholder="请选择" >
            <el-option
              v-for="option in selectedOption"
              :key="option.id"
              :label="option.name"
              :value="option.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <!-- 确定和取消按钮 -->
        <el-button type="primary" :plain="true" align="center" @click="submitAdd">确定</el-button>
        <el-button align="center" @click="cancelAdd">取消</el-button>
      </el-form>
    </el-dialog>
  </div>
</template>

<style>
.flex-container {
  display: flex;
  align-items: center;
}
</style>

<script>
import axios from 'axios'
export default {
  data() {
    return {
      addData: {
        number: '',
        customerId: '',
        issueDate: '',
        dueDate: '',
        totalAmount: '',
        userId: '',
        pass: ''
      },
      selectedNumber: [],
      selectedUser: [],
      selectedOption: [],
      addIn: false,
      currentPage: 1, // 当前页码
      pageSize: 8, // 每页显示的数据条数
      total: 0, // 表格中数据的总条数
      search: {
        userId: '',
        approveStatus: '',
        number: '',
        issueDate: ''
      },
      updateValue: 0,
      editdata: {
        id: '',
        number: '',
        customerId: '',
        issueDate: '',
        dueDate: '',
        totalAmount: '',
        status: '',
        approveStatus: '',
        approveDate: '',
        userId: ''
      },
      editFormVisible: false, // 控制弹出框的显示与隐藏
      list: {
        id: '',
        number: '',
        customerId: '',
        issueDate: '',
        dueDate: '',
        totalAmount: '',
        status: '',
        approveStatus: '',
        approveDate: '',
        userId: '',
        employee: {
          name: '',
          id: ''
        }
      },
      listLoading: true
    }
  },
  computed: {
    // eslint-disable-next-line vue/no-dupe-keys
    list() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.tableData.slice(start, end) // 根据当前页码和每页条数截取分页数据
    }
  },

  created() {
    this.fetchData(this.pageSize, this.currentPage)
    this.getNumbers()
    this.getUsers()
    this.userList()
  },
  methods: {
    userList() {
      axios.get('http://localhost:10010/user/list').then(
        response => {
          this.selectedOption = response.data
        }
      )
    },
    verifyuser(id) {
      for (var i = 0 ; i < this.selectedOption.length ; i++ ) {
        if(this.selectedOption[i].id == id){
          return this.selectedOption[i].name
        }
      }
    },
    getUsers() {
      axios.get('http://localhost:10010/dev-api/invoice/getUser')
        .then(response => {
          this.selectedUser = response.data
        })
    },
    getNumbers() {
      axios.get('http://localhost:10010/dev-api/invoice/getNumber')
        .then(response => {
          this.selectedNumber = response.data
        })
    },
    addInvoice() {
      this.addIn = true
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
      axios.post('http://localhost:10010/dev-api/invoice/listwith', formData)
        .then(response => {
          // 在这里处理后端返回的数据
          // eslint-disable-next-line no-sequences
          this.list = response.data.data.records
          this.total = response.data.data.total
          this.listLoading = false
        })
    },
    approve(row, flag) {
      if (row.approveStatus === 1 || row.approveStatus === 2) {
        this.$message.error('该单据已审批或报废，不可再次操作')
      } else {
        axios.put(`http://localhost:10010/dev-api/invoice/updateStatus/${flag}`, row)
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
    verifyStatus(status) {
      if (status === 0) {
        return '未审批'
      } else if (status === 1) {
        return '已审批'
      } else if (status === 2) {
        return '已作废'
      }
    },
    fetchData(size, page) {
      this.listLoading = true
      axios.post('http://localhost:10010/dev-api/invoice/list', { size, page })
        .then(response => {
          // 在这里处理后端返回的数据
          // eslint-disable-next-line no-sequences
          this.list = response.data.data.records
          this.total = response.data.data.total
          this.listLoading = false
        })
    },
    EditRow(row) {
      this.editdata = { ...row }
      this.editFormVisible = true
    },
    DeleteRow(row) {
      this.$confirm('是否确认删除', '提示', {
        iconClass: 'el-icon-question', // 自定义图标样式
        confirmButtonText: '确认', // 确认按钮文字更换
        cancelButtonText: '取消', // 取消按钮文字更换
        showClose: true, // 是否显示右上角关闭按钮
        type: 'warning'// 提示类型  success/info/warning/error
      }).then(() => {
        axios.delete(`http://localhost:10010/dev-api/invoice/delete/${row.id}`)
          .then(response => {
            this.fetchData(this.pageSize, this.currentPage)
            this.$message({
              message: '删除成功',
              type: 'success'
            })
          })
        // 确认操作
      }).catch(() => {
        // 取消操作
      })
    },
    onSubmit() {
      axios.put('http://localhost:10010/dev-api/invoice/update', this.editdata)
        .then(response => {
          console.log(response.data)
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
      axios.post('http://localhost:10010/dev-api/invoice/add', this.addData)
        .then(response => {
          this.fetchData(this.pageSize, this.currentPage)
          this.addIn = false
          this.$message({
            message: '新增成功',
            type: 'success'
          })
          this.addData = {}
        })
    }
  }
}
</script>

