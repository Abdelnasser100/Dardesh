//
//  MSGViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 07/10/2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift


class MSGViewController: MessagesViewController {
    
    
    //MARK: - View Coustomized
    
    let leftBarButtonView : UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    }()
    
    
    let titelLabel : UILabel = {
        let titel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        titel.textAlignment = .left
        titel.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        titel.adjustsFontSizeToFitWidth = true
        return titel
    }()
    
    
    let subTitelLabel : UILabel = {
        let titel = UILabel(frame: CGRect(x: 5, y: 22, width: 100, height: 25))
        titel.textAlignment = .left
        titel.font = UIFont.systemFont(ofSize: 13,weight: .medium)
        titel.adjustsFontSizeToFitWidth = true
        return titel
    }()
    
    
    //MARK: - Vars
    
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    
    let refreshController = UIRefreshControl()
    let micButton = InputBarButtonItem()
    
    
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    
    var mkMessages:[MKMessage] = []
    var allLocalMessages:Results<LocalMessage>!
    lazy var realm = try! Realm()
    
    var notifcationToken:NotificationToken?
    
    var displaingMessageCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    var typingCount = 0
    
    var gallery:GalleryController!
    
    var longPressGesture:UILongPressGestureRecognizer!
    
    var audioFileName : String = ""
    var audioStartTime:Date = Date()
    
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    
    init(chatId:String,recipientId:String,recipientName:String) {
        super.init(nibName: nil, bundle: nil)
        
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRecognizer()
       configureMessegeCollectionView()
        configerMessageInputBar()
        
        loadMessages()
        
        listenForNewMessage()
        
        configureCustemTitel()
        
        creatTypingObserve()
        
        listenerForReadStatusUpdate()
        
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    
    private func configureMessegeCollectionView(){
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
    }
    
    
    private func configerMessageInputBar(){
        
        messageInputBar.delegate = self
        
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "paperclip",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { (item) in
           
            self.actionAttachMessage()
        }
        
        
        micButton.image = UIImage(systemName: "mic.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        //add gesture recognizer
        
        micButton.addGestureRecognizer(longPressGesture)
            
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        updateMicButtonStatus(show: true)
        
        messageInputBar.inputTextView.isImagePasteEnabled = true
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
        
        
    }
    
    
    //MARK: - long press configuration
    
    private func configureRecognizer(){
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordAndSend))
    }
    
    
    
    //MARK: - Configure custem titel
    
    private func configureCustemTitel(){
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))]
        
        leftBarButtonView.addSubview(titelLabel)
        leftBarButtonView.addSubview(subTitelLabel)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
        
        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
        
        titelLabel.text = self.recipientName
        
        updateTypingIndcator(false)
    }
    
  @objc  func backButtonPressed(){
       removeListeners()
    FChatRoomLisntener.shared.clearUnreadCounterUsingChatRoomId(chatRoomId: chatId)
        
    self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: - Mark Message As read
    
    func updateTypingIndcator(_ localMessage:LocalMessage){
        if localMessage.senderId != User.currentId{
            FMessageListener.shared.updateMessageStatus(localMessage, userId: recipientId)
        }
    }
    
    
    //MARK: - Update typing
    
    
   func updateTypingIndcator(_ show:Bool){
        subTitelLabel.text = show ? "Typing..." : " "
    
    }
    
    
    func startTypingIndecator(){
        
        typingCount += 1
        FTypingListener.saveTypingCounter(typing: true, chatRoomId: chatId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.stopTypingIndicator()
        }
    }
    
    
    func stopTypingIndicator(){
        typingCount += 1
        if typingCount == 0{
            FTypingListener.saveTypingCounter(typing: false, chatRoomId: chatId)
        }
    }
    
    
    func creatTypingObserve(){
        FTypingListener.shared.createTypingObserver(chatRoomId: chatId) { (isTyping) in
            DispatchQueue.main.async {
                self.updateTypingIndcator(isTyping)
            }
        }
    }
 
    
    
//MARK: - Update mic
    
    func updateMicButtonStatus(show:Bool)
    {
        if show{
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 50, animated: false)
            
        }else{
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
        }
    }
   

    
    //MARK: - Action
    
    func send(text:String?,photo:UIImage?,video:Video?,audio:String?,location:String?,audioDuration:Float = 0.0){
        
        Outgoing.sendMessage(chatId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [User.currentId,recipientId])
    
    }
    
    
    
    //MARK: - record and send function
    
    @objc func recordAndSend(){
        
        switch longPressGesture.state{
      
        case .began:
             
            //record and start recird
            audioFileName = Date().stringDate()
            audioStartTime = Date()
            AudioRecorder.shared.startRecording(fileName: audioFileName)
            
        case .ended:
            //stop recording
            AudioRecorder.shared.finishRecording()
            
            if fileExistsAtPath(path: audioFileName + ".m4a"){
                
                let audioDuration = audioStartTime.interval(ofComponent: .second, to: Date())
                
                send(text: nil, photo: nil, video: nil, audio: audioFileName, location: nil,audioDuration: audioDuration)
            }
            
        @unknown default:
            print("Unknown")
        }
    
    }
    
    
    //MARK: - Action Attached
    
    private func actionAttachMessage(){
        
        messageInputBar.inputTextView.resignFirstResponder()
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoOrVideo = UIAlertAction(title: "Camera", style: .default) { (alert) in
            self.showImageGallery(camera: true)
        }
        let shareMedai = UIAlertAction(title: "Library", style: .default) { (alert) in
            self.showImageGallery(camera: false)
        }
        let shareLocation = UIAlertAction(title: "Show Location", style: .default) { (alert) in
            
            if let _ = LocationManager.shared.currentLocation{
                self.send(text: nil, photo: nil, video: nil, audio: nil, location: kLOCATION)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        takePhotoOrVideo.setValue(UIImage(systemName: "camera"), forKey: "image")
        shareMedai.setValue(UIImage(systemName: "photo.fill"), forKey: "image")
        shareLocation.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey: "image")
        
        optionMenu.addAction(takePhotoOrVideo)
        optionMenu.addAction(shareMedai)
        optionMenu.addAction(shareLocation)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    //MARK: - UIScrollViewDelegete
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing{
            if displaingMessageCount < allLocalMessages.count{
                self.insertMoreMKMessages()
                messagesCollectionView.reloadDataAndKeepOffset()
            }
        }
        refreshController.endRefreshing()
    }
    
    
    //MARK: - load Messages
    
    private func loadMessages(){
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        
        if allLocalMessages.isEmpty{
            checkForOldMessage()
        }
        
       
        notifcationToken = allLocalMessages.observe({(change:RealmCollectionChange) in
            switch change{
            case .initial:
                self.insertMKMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
                
            case .update(_, _, let insertions, _):
                for index in insertions{
                    self.insertMKMessage(localMessage: self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: false)
                    self.messagesCollectionView.scrollToBottom(animated: false)
                }
            case .error(let error):
                print("error no new insertion",error.localizedDescription)
            }
        })
        
    }
    
    
    private func insertMKMessage(localMessage:LocalMessage){
        updateTypingIndcator(localMessage)
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage:localMessage)
        self.mkMessages.append(mkMessage)
        
        displaingMessageCount += 1
    }
    
    
    private func insertOlderMKMessage(localMessage:LocalMessage){
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage:localMessage)
        self.mkMessages.insert(mkMessage, at: 0)
        
        displaingMessageCount += 1
    }
    
    private func insertMKMessages(){
        
        maxMessageNumber = allLocalMessages.count - displaingMessageCount
        minMessageNumber = maxMessageNumber - 12
        
        if minMessageNumber < 0{
             minMessageNumber = 0
        }
        
        for i in minMessageNumber ..< maxMessageNumber{
            insertMKMessage(localMessage: allLocalMessages[i])
        }
        
    }
    
    
    
    private func insertMoreMKMessages(){
        
        maxMessageNumber = minMessageNumber - 1
        minMessageNumber = maxMessageNumber - 12
        
        if minMessageNumber < 0{
             minMessageNumber = 0
        }
        
        for i in (minMessageNumber ... maxMessageNumber).reversed(){
            insertOlderMKMessage(localMessage: allLocalMessages[i])
        }
        
    }
    
    private func checkForOldMessage(){
        FMessageListener.shared.checkForOldMessage(User.currentId, collectionId: chatId)
    }
    
    
    private func listenForNewMessage(){
        FMessageListener.shared.listenForNewMessages(User.currentId, collectionId: chatId, lastMessage: lastMessageDate())
    }
    
    
    private func lastMessageDate()->Date{
        let lastMessage = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second,value: 1, to: lastMessage) ?? lastMessage
    }
    
    
    private func removeListeners(){
        FTypingListener.shared.removeTypingListener()
        FMessageListener.shared.removeNewMessageListeners()
    }
    
    
    
    //MARK: - Update Read Status
    
    private func updateReadStatus(_ updateLocalMessage:LocalMessage){
        
        for index in 0 ..< mkMessages.count{
            let tempMessage = mkMessages[index]
            if updateLocalMessage.id == tempMessage.messageId{
                mkMessages[index].status = updateLocalMessage.status
                mkMessages[index].readDate = updateLocalMessage .readDate
                
                RealmManager.shared.save(updateLocalMessage)
                
                if mkMessages[index].status == kREAD{
                    self.messagesCollectionView.reloadData()
                }
                
                
            }
        }
        
    }
    
    
    private func listenerForReadStatusUpdate(){
        FMessageListener.shared.listenerForReadStatus(User.currentId, collectionId: chatId) { (updateMessage) in
            self.updateReadStatus(updateMessage)
        }
    }
    
    
    
    //MARK: - Gallery
    
    private func showImageGallery(camera:Bool){
        
        gallery = GalleryController()
        gallery.delegate = self
        Config.tabsToShow = camera ? [.cameraTab] : [.imageTab,.videoTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        Config.VideoEditor.maximumDuration = 30
        
        self.present(gallery, animated: true, completion: nil)
    }
    
}


extension MSGViewController:GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        //TODO:- Send photo image
        if images.count > 0{
            images.first?.resolve(completion: { (image) in
                self.send(text: nil, photo: image, video: nil, audio: nil, location: nil)
            })
        }
        
        
        
        print("we have selected \(images.count)")
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        self.send(text: nil, photo: nil, video: video, audio: nil, location: nil)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
