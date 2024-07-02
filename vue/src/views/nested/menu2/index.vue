<template>
  <div class="app-container">
    <el-form ref="myForm" :model="search" label-width="80px">
      <div class="flex-container">
        <el-row>
          <el-col :span="1">
            <el-button type="primary" @click="addIn=true">生成</el-button>
          </el-col>
          <el-col :span="4">
            <el-form-item label="部门">
              <el-select v-model="search.department" placeholder="请选择">
                <el-option
                  v-for="option in selectedOption"
                  :key="option"
                  :label="option"
                  :value="option"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="职位">
              <el-select v-model="search.position" placeholder="请选择">
                <el-option
                  v-for="option in selectedPosition"
                  :key="option"
                  :label="option"
                  :value="option"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="性别">
              <el-select v-model="search.gender" placeholder="选择性别" style="width:90%;">
                <el-option label="男" value="男" />
                <el-option label="女" value="女" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-form-item label="状态">
              <el-select v-model="search.active" placeholder="选择状态" style="width:90%;">
                <el-option label="离职" value="0" />
                <el-option label="在职" value="1" />
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
      fit
    >
      <el-table-column label="姓名" width="70" align="center">
        <template slot-scope="scope">
          {{ scope.row.name }}
        </template>
      </el-table-column>
      <el-table-column label="性别" width="70" align="center">
        <template slot-scope="scope">
          {{ scope.row.gender }}
        </template>
      </el-table-column>
      <el-table-column label="年龄" width="70" align="center">
        <template slot-scope="scope">
          {{ scope.row.age }}
        </template>
      </el-table-column>
      <el-table-column label="入职日期" width="110" align="center">
        <template slot-scope="scope">
          {{ scope.row.hireDate }}
        </template>
      </el-table-column>
      <el-table-column class-name="status-col" label="状态" width="80" align="center">
        <template slot-scope="scope">
          <el-tag v-if="verifyStatus(scope.row.isActive)==='在职'" round type="success">{{ verifyStatus(scope.row.isActive) }}</el-tag>
          <el-tag v-else-if="verifyStatus(scope.row.isActive)==='离职'" round type="danger">{{ verifyStatus(scope.row.isActive) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="电话" width="110" align="center">
        <template slot-scope="scope">
          {{ scope.row.phone }}
        </template>
      </el-table-column>
      <el-table-column label="邮箱" width="175" align="center">
        <template slot-scope="scope">
          {{ scope.row.email }}
        </template>
      </el-table-column>
      <el-table-column label="地址" width="120" align="center">
        <template slot-scope="scope">
          {{ scope.row.address }}
        </template>
      </el-table-column>
      <el-table-column label="出生日期" width="100" align="center">
        <template slot-scope="scope">
          {{ scope.row.dateOfBirth }}
        </template>
      </el-table-column>
      <el-table-column label="部门" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.department }}
        </template>
      </el-table-column>
      <el-table-column label="职位" width="90" align="center">
        <template slot-scope="scope">
          {{ scope.row.position }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="135" align="center">
        <template slot-scope="scope">
          <el-button circle type="primary" icon="el-icon-edit" round @click="EditRow(scope.row) " />
          <el-button circle type="warning" :plain="true" round @click="offwork(scope.row,scope.row.id)">离职</el-button>
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
      title="修改员工信息"
      :visible="editFormVisible"
      @close="editFormVisible = false"
    >
      <el-form ref="editdata" :model="editdata" label-width="80px" size="mini">
        <el-row>
          <el-col span="12">
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
          <el-col span="12">
            <el-form-item label="姓名">
              <el-input v-model="editdata.name" maxlength="5" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col span="12">
            <el-form-item label="邮箱">
              <el-input v-model="editdata.email" maxlength="30" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col span="12">
            <el-form-item label="手机">
              <el-input v-model="editdata.phone" maxlength="14" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col span="12">
            <el-form-item label="部门">
              <el-select v-model="editdata.department" placeholder="请选择">
                <el-option
                  v-for="option in selectedOption"
                  :key="option"
                  :label="option"
                  :value="option"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col span="12">
            <el-form-item label="职位">
              <el-select v-model="editdata.position" placeholder="请选择">
                <el-option
                  v-for="option in selectedPosition"
                  :key="option"
                  :label="option"
                  :value="option"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col span="12">
            <el-form-item label="性别">
              <el-select v-model="editdata.gender" placeholder="选择性别" style="width:90%;">
                <el-option label="男" value="男" />
                <el-option label="女" value="女" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col span="12">
            <el-form-item label="地址">
              <el-input v-model="editdata.address" maxlength="30" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col span="12">
            <el-form-item label="入职日期">
              <el-date-picker v-model="editdata.hireDate"  :disabled="true"/>
            </el-form-item>
          </el-col>
          <el-col span="12">
            <el-form-item label="出生日期">
              <el-date-picker v-model="editdata.dateOfBirth" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <!-- 确定和取消按钮 -->
      <el-button type="primary" :plain="true" @click="onSubmit">确定</el-button>
      <el-button @click="onCancel">取消</el-button>
    </el-dialog>
    <el-dialog
      title="新增中级员工"
      :visible="addIn"
      @close="addIn = false"
    >
      <el-form ref="addData" :model="addData" label-width="80px" size="mini">
        <el-row style="display: none">
          <el-col span="12">
            <!-- 表单项 -->
            <el-form-item label="主键">
              <el-input
                v-model="addData.id"
                placeholder="主键id"
                :disabled="true"
                size="mini"
                maxlength="5"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col span="12">
            <el-form-item label="姓名">
              <el-input v-model="addData.name" maxlength="5" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col span="12">
            <el-form-item label="邮箱">
              <el-input v-model="addData.email" maxlength="30" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col span="12">
            <el-form-item label="手机">
              <el-input v-model="addData.phone" maxlength="14" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col span="12">
            <el-form-item label="部门">
              <el-select v-model="addData.department" placeholder="请选择">
                <el-option
                  v-for="option in selectedOption"
                  :key="option"
                  :label="option"
                  :value="option"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col span="12">
            <el-form-item label="职位">
              <el-select v-model="addData.position" placeholder="请选择">
                <el-option
                  v-for="option in selectedPosition"
                  :key="option"
                  :label="option"
                  :value="option"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col span="12">
            <el-form-item label="性别">
              <el-select v-model="addData.gender" placeholder="选择性别" style="width:90%;">
                <el-option label="男" value="男" />
                <el-option label="女" value="女" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col span="12">
            <el-form-item label="地址">
              <el-input v-model="addData.address" maxlength="30" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col span="12">
            <el-form-item label="入职日期">
              <el-date-picker v-model="addData.hireDate" />
            </el-form-item>
          </el-col>
          <el-col span="12">
            <el-form-item label="出生日期">
              <el-date-picker v-model="addData.dateOfBirth" />
            </el-form-item>
          </el-col>
        </el-row>
        <!-- 确定和取消按钮 -->
        <el-button type="primary" :plain="true" align="center" @click="submitAdd">确定</el-button>
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
        ranking: '中级',
        department: '',
        position: '',
        gender: '',
        isActive: ''
      },
      selectedOption: [],
      selectedPosition: [],
      list: {
      },
      editdata: {
      },
      addData: {
      }
    }
  },
  created() {
    this.fetchData(this.pageSize, this.currentPage)
    this.departmentList()
    this.getRanking()
  },
  mounted() {
  },
  methods: {
    cancelAdd() {
      this.addIn = false
      this.addData = {}
    },
    submitAdd() {
      axios.post('http://localhost:10010/user/add', this.addData)
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
    },
    offwork(row, id) {
      if (this.verifyStatus(row.isActive) === '离职') {
        this.$message.error('该员工已离职')
      } else {
        axios.put(`http://localhost:10010/user/updateStatus/${id}`)
          .then(response => {
            this.searchWithForm()
            this.$message({
              message: '离职成功',
              type: 'success'
            })
          })
      }
    },
    onSubmit() {
      axios.put('http://localhost:10010/user/update', this.editdata)
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
      this.editdata = { ...row }
      this.editFormVisible = true
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
      console.log(formData)
      axios.post('http://localhost:10010/user/listwith', formData)
        .then(response => {
          this.list = response.data.data.records
          this.total = response.data.data.total
          this.listLoading = false
        })
    },
    fetchData(size, page) {
      this.listLoading = true
      axios.post('http://localhost:10010/user/listzj', { size, page })
        .then(response => {
          this.list = response.data.data.records
          console.log(response.data.data.records)
          this.total = response.data.data.total
          this.listLoading = false
        })
    },
    verifyStatus(active) {
      if (active === false) {
        return '离职'
      } else if (active === true) {
        return '在职'
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
    departmentList() {
      axios.get('http://localhost:10010/user/department').then(
        response => {
          this.selectedOption = response.data
        }
      )
    },
    getRanking() {
      axios.get('http://localhost:10010/user/position').then(
        response => {
          this.selectedPosition = response.data
        }
      )
    }
  }
}
</script>
