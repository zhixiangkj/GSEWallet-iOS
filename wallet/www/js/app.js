/**
 * Created by fjl on 2018/11/15
 */

// 节流函数: 防止函数高频调用
const throttle = (func, time = 300) => {
  let canRun = true
  return (data) => {
    if (!canRun) return
    func(data)
    canRun = false
    setTimeout(function () {
      canRun = true
    }, time)
  }
}
const message = document.getElementById('message')
const pathsUl = document.getElementById('paths')
const useCamera = () => {
  const options = {
    quality: 100,
    mediaType: window.Camera.MediaType.VIDEO
  }
  const onSuccess = (data) => {
    console.log(data)
  }
  const onError = (err) => {
    console.log(err)
  }
  navigator.camera.getPicture(onSuccess, onError, options)
}
// 扫码插件2
const useScanner2 = () => {
  window.QRScanner.scan(displayContents)

  function displayContents (err, text) {
    console.log(err, text)
    if (err) {
      // an error occurred, or the scan was canceled (error code `6`)
    } else {
      // The scan completed, display the contents of the QR code:
      alert(text)
      setTimeout(() => {
        window.QRScanner.scan(displayContents)
      }, 3000)
    }
  }

  // Make the webview transparent so the video preview is visible behind it.
  window.QRScanner.show()
}
// 定位插件
const useGeolocation = () => {
  const paths = []
  const options = {}
  pathsUl.innerHTML = ''
  const onSuccess = (result) => {

    const li = document.createElement('li')
    li.style.backgroundColor = '#fff'
    li.style.lineHeight = '45px'
    li.style.marginBottom = '10px'
    const {altitude, longitude} = result.coords
    li.innerHTML = `
    <div class="altitude">
    ${altitude}
    </div>
    <div class="longitude">
    ${longitude}
    </div> 
    `
    pathsUl.appendChild(li)
    paths.push(result)
    message.innerText = `${paths.length}`
  }
  const onError = (err) => {
    if (err.code === 1) {
      alert(err.message || '应用没有定位权限')
    } else {
      alert(err.message)
    }

    console.error(err)
  }
  const watchID = navigator.geolocation.watchPosition(throttle(onSuccess), throttle(onError), options)
  console.log(watchID)
}
// 相机
const cameraBtn = document.getElementById('use_camera')
cameraBtn.onclick = useCamera

// 扫码
const scannerBtn = document.getElementById('use_scanner')
scannerBtn.onclick = useScanner2

// 定位
const geolocationBtn = document.getElementById('use_geolocation')
geolocationBtn.onclick = useGeolocation

// 支付
const gsePayBtn = document.getElementById('use_gse_pay')
gsePayBtn.onclick = () => {
  const params = {
    paymentAmount: 12.1122, // 付款金额 （必选）
    paymentCountry: 'US', // 国家 （可选， 默认US）
    paymentCurrency: 'usd' // 货币 （可选，默认usd:美元）
  }
  GseWallet.pay(params, (result) => {
    const {code, message, data} = result
    switch (code) {
      case 0 : // 支付成功

        break;
      case 1 : // 支付取消

        break;
      case 2 : // 支付失败

        break;
    }
    console.log(message)
    console.log(data)
  }, (err) => {
    console.log(err)
  })
}

// 关闭当前浏览器
const closeWebViewBtn = document.getElementById('use_close_webview')
closeWebViewBtn.onclick = () => {
  GseWallet.closeWebView()
}
