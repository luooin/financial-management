<template>
  <div class="app-container">
    <el-form ref="myForm" :model="search" label-width="80px">
      <div class="flex-container">
        <el-row>
          <el-col :span="1">
            <el-button type="primary" @click="addIn=true">生成</el-button>
          </el-col>
          <el-col :span="4">
            <el-form-item label="姓名" >
              <el-select v-model="search.employeeId" placeholder="请选择" >
                <el-option
                  v-for="option in selectedOption"
                  :key="option.id"
                  :label="option.name"
                  :value="option.id"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="7">
            <el-form-item label="工资月份">
              <el-date-picker
                v-model="search.salaryMonth"
                type="monthrange"
                clearable
                start-placeholder="起始月份"
                value-format="yyyy-MM"
                end-placeholder="结束月份"
                range-separator="至"
                @change="chooseMonths"
                style="width: 90%;"
              >
              </el-date-picker>

            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="绩效比例">
              <el-input v-model="search.percent" prefix-icon="el-icon-search" placeholder="请输入绩效" maxlength="3" show-word-limit style="width: 100%;"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="职级">
              <el-select v-model="search.ranking" placeholder="请输入职级" style="width:90%;">
                <el-option label="高级" value="高级"></el-option>
                <el-option label="中级" value="中级"></el-option>
                <el-option label="初级" value="初级"></el-option>
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
      style="width: 100%"
      fit>
      <el-table-column label="员工" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.employeeName }}
        </template>
      </el-table-column>
      <el-table-column label="基本工资" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.basicSalary }}
        </template>
      </el-table-column>
      <el-table-column label="工资月份" width="110" align="center">
        <template slot-scope="scope">
          {{ scope.row.salaryMonth}}
        </template>
      </el-table-column>
      <el-table-column label="绩效工资" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.performanceSalary }}
        </template>
      </el-table-column>
      <el-table-column label="完成比例" width="130" align="center">
        <template slot-scope="scope">
          <el-progress :percentage="scope.row.percent * 100"></el-progress>
        </template>
      </el-table-column>
      <el-table-column label="五险基数" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.socialSecurityBase }}
        </template>
      </el-table-column>
      <el-table-column label="五险比例" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.socialSecurityRate }}
        </template>
      </el-table-column>
      <el-table-column label="公积金基数" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.housingFundBase }}
        </template>
      </el-table-column>
      <el-table-column label="公积金比例" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.housingFundRate }}
        </template>
      </el-table-column>
      <el-table-column label="奖金" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.annualBonus }}
        </template>
      </el-table-column>
      <el-table-column label="入职日期" width="110" align="center">
        <template slot-scope="scope">
          {{ scope.row.hireDate }}
        </template>
      </el-table-column>
      <el-table-column label="职位" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.position }}
        </template>
      </el-table-column>
      <el-table-column label="到手工资" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.getSalary }}
        </template>
      </el-table-column>
      <el-table-column class-name="status-col" label="状态" width="110" align="center">
        <template slot-scope="scope">
          <el-tag v-if="verifyStatus(scope.row.status)==='已发放'" type="success">{{ verifyStatus(scope.row.status) }}</el-tag>
          <el-tag v-else-if="verifyStatus(scope.row.status)==='未发放'" type="danger">{{ verifyStatus(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="请假天数" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.offDays }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="240"  align="center">
        <template slot-scope="scope">
          <el-button circle type="primary" icon="el-icon-edit" round @click="EditRow(scope.row) "></el-button>
          <el-button circle type="warning" :plain="true" round @click="approve(scope.row,1)">发放</el-button>
          <el-button circle type="warning" :plain="true" round @click="approve(scope.row,2)">作废</el-button>
          <el-button circle type="danger" icon="el-icon-delete" :plain="true" round @click="DeleteRow(scope.row)"></el-button>
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
      title="生成工资单"
      :visible="addIn"
      @close="addIn = false"
    >
      <el-form ref="addData" :model="addData" label-width="80px" size="mini" >

        <el-form-item label="员工" >
<!--          <el-input v-model="addData.employeeId" maxlength="3" show-word-limit />-->
          <el-select v-model="addData.employeeId" placeholder="请选择" >
            <el-option
              v-for="option in selectedOption"
              :key="option.id"
              :label="option.name"
              :value="option.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="工资月份" >
          <el-date-picker
            v-model="addData.salaryMonth"
            type="month"
            placeholder="选择月">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="绩效完成情况" >
          <el-input v-model="addData.percent" maxlength="5" show-word-limit />
        </el-form-item>
        <el-form-item label="请假天数" >
          <el-input v-model="addData.offDays" maxlength="4" show-word-limit />
        </el-form-item>
        <el-form-item label="奖金" >
          <el-input v-model="addData.annualBonus" maxlength="5" show-word-limit />
        </el-form-item>
        <!-- 确定和取消按钮 -->
        <el-button type="primary" :plain="true" align="center" @click="submitAdd" >确定</el-button>
        <el-button @click="cancelAdd" align="center">取消</el-button>
      </el-form>
    </el-dialog>

    <el-dialog
      title="修改工资单"
      :visible="editFormVisible"
      @close="editFormVisible = false"
    >
      <el-form ref="editdata" :model="editdata" label-width="80px" size="mini">
        <el-row>
          <el-col :span="10">
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
          </el-col>
          <el-col :span="11">
            <el-form-item label="工资月份">
              <el-date-picker  v-model="editdata.salaryMonth" type="month" placeholder="选择月份" style="width: 100%;" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="10">
            <el-form-item label="绩效完成情况" >
              <el-input v-model="editdata.percent" maxlength="5" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col :span="11">
            <el-form-item label="请假天数" >
              <el-input v-model="editdata.offDays" maxlength="4" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="10">
            <el-form-item label="五险标准" >
              <el-input v-model="editdata.socialSecurityBase" maxlength="5" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col :span="11">
            <el-form-item label="五险比例" >
              <el-input v-model="editdata.socialSecurityRate" maxlength="5" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="10">
            <el-form-item label="公积金标准" >
              <el-input v-model="editdata.housingFundBase" maxlength="5" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col :span="11">
            <el-form-item label="公积金比例" >
              <el-input v-model="editdata.housingFundRate" maxlength="5" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="10">
            <el-form-item label="奖金" >
              <el-input v-model="editdata.annualBonus" maxlength="5" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col :span="11">
            <el-form-item  v-if="verifyStatus(editdata.status)==='已发放'" label="审批状态">
              <el-input
                placeholder="已发放"
                :disabled="true">
              </el-input>
            </el-form-item>
            <el-form-item  v-else-if="verifyStatus(editdata.status)==='未发放'" label="审批状态">
              <el-input
                placeholder="未发放"
                :disabled="true">
              </el-input>
            </el-form-item>
            <el-form-item  v-else-if="verifyStatus(editdata.status)==='已作废'" label="审批状态">
              <el-input
                placeholder="已作废"
                :disabled="true">
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <!-- 确定和取消按钮 -->
      <el-button type="primary" :plain="true" @click="onSubmit">确定</el-button>
      <el-button @click="onCancel">取消</el-button>
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
        employeeId: '',
        salaryMonth: [],
        ranking: '',
        percent: '',
        status: ''
      },
      selectedOption: [],
      list: {
        employeeId: '',
        employeeName: '',
        salaryMonth: '',
        ranking: '',
        percent: '',
        id: '',
        basicSalary: '',
        performanceSalary: '',
        socialSecurityBase: '',
        socialSecurityRate: '',
        housingFundBase: '',
        housingFundRate: '',
        annualBonus: '',
        hireDate: '',
        position: '',
        getSalary: '',
        offDays: '',
        status: ''
      },
      editdata: {
        employeeId: '',
        salaryMonth: '',
        ranking: '',
        percent: '',
        id: '',
        basicSalary: '',
        performanceSalary: '',
        socialSecurityBase: '',
        socialSecurityRate: '',
        housingFundBase: '',
        housingFundRate: '',
        annualBonus: '',
        hireDate: '',
        position: '',
        getSalary: '',
        offDays: '',
        status: ''
      },
      addData: {
        offDays: '',
        employeeId: '',
        salaryMonth: '',
        annualBonus: '',
        percent: ''
      }
    }
  },
  created() {
    this.fetchData(this.pageSize, this.currentPage)
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
    onSubmit() {
      axios.put('http://localhost:10010/salary/update', this.editdata)
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
    format(percentage) {
      return percentage === 100 ? '满' : `${percentage}%`
    },
    approve(row, flag) {
      if (row.status === 1 || row.status === 2) {
        this.$message.error('该单据已发放或报废，不可再次操作')
      } else {
        axios.put(`http://localhost:10010/salary/updateStatus/${flag}`, row)
          .then(response => {
            this.searchWithForm()
            if (flag === 1) {
              this.$message({
                message: '发放成功',
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
    EditRow(row) {
      // this.editFormData = { ...row }
      this.editdata = { ...row }
      this.editFormVisible = true
    },
    verifyStatus(status) {
      if (status === 0) {
        return '未发放'
      } else if (status === 1) {
        return '已发放'
      }
    },
    DeleteRow(row) {
      axios.delete(`http://localhost:10010/salary/delete/${row.id}`)
        .then(response => {
          this.fetchData(this.pageSize, this.currentPage)
          this.$message({
            message: '删除成功',
            type: 'success'
          })
        })
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
      this.listLoading = true
      axios.post('http://localhost:10010/salary/list', { size, page })
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
      for (const i in this.search.salaryMonth) {
        this.search.salaryMonth[i] += '-01'
      }
      const form = this.$refs.myForm
      let formData = form.model
      // 将formData重新赋值为响应式的对象
      formData = Object.assign({}, formData)
      formData.size = this.pageSize
      formData.page = this.currentPage
      this.$set(formData, 'size', this.pageSize)
      this.$set(formData, 'page', this.currentPage)
      axios.post('http://localhost:10010/salary/listwith', formData)
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
      axios.post('http://localhost:10010/salary/add', this.addData)
        .then(response => {
          if (response.data.code === 1) {
            this.fetchData(this.pageSize, this.currentPage)
            this.addIn = false
            this.$message({
              message: '生成成功',
              type: 'success'
            })
            this.addData = {}
          } else if (response.data.code === 0) {
            this.addData = {}
            this.fetchData(this.pageSize, this.currentPage)
            this.addIn = false
            this.$message.error('该员工该月已生成工资单')
          }
        })
    }
  }
}
</script>

