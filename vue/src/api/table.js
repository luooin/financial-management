import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/invoice/list',
    method: 'get',
    params
  })
}
